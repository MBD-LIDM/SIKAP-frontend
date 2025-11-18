// lib/core/auth/ensure_guest_auth.dart

import 'package:uuid/uuid.dart';

import 'package:sikap/core/auth/guest_auth_gate.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';

final SessionService _sessionService = SessionService();
late final GuestAuthGate _guestAuthGate =
    GuestAuthGate(_sessionService, _quickLogin);

GuestAuthGate guestAuthGateInstance() => _guestAuthGate;
SessionService guestSession() => _sessionService;

Future<void> ensureGuestAuthenticated({
  String? schoolCode,
  String? gradeStr,
  String? deviceId,
  bool forceRefresh = false,
}) async {
  final normalizedSchoolCode = schoolCode?.trim();
  final normalizedGrade = gradeStr?.trim();
  final normalizedDeviceId = deviceId?.trim();

  final hasProfileInput = normalizedSchoolCode != null ||
      normalizedGrade != null ||
      normalizedDeviceId != null;

  if (hasProfileInput) {
    await _sessionService.saveProfile(
      schoolCode: normalizedSchoolCode,
      grade: normalizedGrade,
      deviceId: normalizedDeviceId,
    );
  }

  final shouldResetSession =
      forceRefresh || normalizedSchoolCode != null || normalizedGrade != null;
  if (shouldResetSession) {
    print(
        '[GUEST_AUTH] Clearing cached guest session before re-login (force=$forceRefresh, schoolCodeProvided=${normalizedSchoolCode != null}, gradeProvided=${normalizedGrade != null})');
    await _sessionService.clearGuest();
  }

  await _guestAuthGate.ensure();
}

Future<void> _quickLogin() async {
  final profile = await _sessionService.loadProfile();

  final scode = (profile.schoolCode ?? '').trim().toUpperCase();
  if (scode.isEmpty) {
    throw ApiException(message: "Kode sekolah wajib diisi", code: 400);
  }

  print('[GUEST_AUTH] Starting quick login with school_code: $scode');
  print('[GUEST_AUTH] Current profile - schoolId: ${profile.schoolId}, grade: ${profile.grade}, deviceId: ${profile.deviceId}');

  final gradeStr = (profile.grade ?? '').trim();
  final grade = int.tryParse(gradeStr);
  if (grade == null) {
    throw ApiException(message: "Grade harus numerik (10/11/12).", code: 400);
  }

  final deviceFromProfile = profile.deviceId ?? '';
  final normalizedDevice = deviceFromProfile.trim().isEmpty
      ? const Uuid().v4()
      : deviceFromProfile.trim();
  if (normalizedDevice != deviceFromProfile) {
    await _sessionService.saveProfile(deviceId: normalizedDevice);
  }

  final payload = {
    "school_code": scode,
    "grade": grade,
    "device_id": normalizedDevice,
  };

  print('[GUEST_AUTH] Sending quick-login request with payload: $payload');

  final response = await ApiClient().post<Map<String, dynamic>>(
    "/api/accounts/student/quick-login/",
    payload,
    headers: const {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    expectEnvelope: false,
    transform: (raw) => Map<String, dynamic>.from(raw as Map),
  );

  // Dukung respons envelope atau plain: {data:{...}} atau {...}
  final root = response.data;
  final Map<String, dynamic> data = (root is Map && root['data'] is Map)
      ? Map<String, dynamic>.from(root['data'] as Map)
      : Map<String, dynamic>.from(root as Map);

  print('[GUEST_AUTH] Quick-login response received');
  print('[GUEST_AUTH] Response data keys: ${data.keys.toList()}');
  
  // CRITICAL: Check if school_id is in the response
  final schoolIdFromResponse = data['school_id'];
  if (schoolIdFromResponse != null) {
    print('[GUEST_AUTH] ✅ school_id found in response: $schoolIdFromResponse');
    // Save school_id to profile if provided
    final schoolId = schoolIdFromResponse is num 
        ? schoolIdFromResponse.toInt() 
        : int.tryParse(schoolIdFromResponse.toString());
    if (schoolId != null) {
      await _sessionService.saveProfile(schoolId: schoolId, schoolCode: scode);
      print('[GUEST_AUTH] ✅ Saved school_id $schoolId to profile');
    }
  } else {
    print('[GUEST_AUTH] ⚠️ WARNING: school_id NOT found in quick-login response!');
    print('[GUEST_AUTH] ⚠️ Backend may be using school_code from token only');
  }

  final rawId = data['guest_id'];
  final guestId =
      (rawId is num) ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '');
  if (guestId == null) {
    throw ApiException(message: "guest_id tidak ditemukan/invalid", code: 500);
  }

  print('[GUEST_AUTH] Guest ID from response: $guestId');

  // Prefer token dari body jika ada, fallback ke header (x-guest-token/x-token)
  final tokenFromBody = (data['token'] ?? data['guest_token'])?.toString();
  final tokenFromHeader = response.headers?['x-guest-token'] ?? response.headers?['x-token'];
  final token = (tokenFromBody != null && tokenFromBody.isNotEmpty)
      ? tokenFromBody
      : (tokenFromHeader != null && tokenFromHeader.isNotEmpty)
          ? tokenFromHeader
          : null;
  if (token == null || token.isEmpty) {
    // BE tidak mengirim token; JANGAN menghapus token lama jika ada.
    final existingToken = await _sessionService.loadGuestToken();
    if (existingToken != null && existingToken.isNotEmpty) {
      await _sessionService.saveGuestAuth(token: existingToken, guestId: guestId);
      print('[GUEST_AUTH] Using existing token for guest_id $guestId');
    } else {
      await _sessionService.saveGuest(guestId: guestId, token: null);
      print('[GUEST_AUTH] No token provided, saved guest_id only');
    }
    return;
  }

  final maskedToken = token.length > 20 
      ? '${token.substring(0, 10)}...${token.substring(token.length - 4)}'
      : '***';
  print('[GUEST_AUTH] Token received: $maskedToken');

  await _sessionService.saveGuestAuth(token: token, guestId: guestId);
  
  // Verify what was saved
  final savedProfile = await _sessionService.loadProfile();
  final savedGuestId = await _sessionService.loadGuestId();
  print('[GUEST_AUTH] ✅ Session saved - guest_id: $savedGuestId, school_id: ${savedProfile.schoolId}, school_code: ${savedProfile.schoolCode}');
}
