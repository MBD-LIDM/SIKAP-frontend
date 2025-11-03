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

/// Ensure a valid guest token exists. When schoolCode/grade/deviceId changes,
/// the existing guest credentials are invalidated so the new guest identity
/// is scoped to the new profile (prevents cross-school report mixing).
Future<void> ensureGuestAuthenticated({
  String? schoolCode,
  String? gradeStr,
  String? deviceId,
  bool forceRefresh = false,
}) async {
  // Load current profile to detect changes that should invalidate guest creds
  final current = await _sessionService.loadProfile();

  // Normalize incoming inputs similarly to _quickLogin
  final newSchool = schoolCode?.trim().toUpperCase();
  final newGrade = gradeStr?.trim();
  final newDevice = deviceId?.trim();

  final currSchool = (current.schoolCode ?? '').trim().toUpperCase();
  final currGrade = (current.grade ?? '').trim();
  final currDevice = (current.deviceId ?? '').trim();

  final changedSchool =
      newSchool != null && newSchool.isNotEmpty && newSchool != currSchool;
  final changedGrade =
      newGrade != null && newGrade.isNotEmpty && newGrade != currGrade;
  final changedDevice =
      newDevice != null && newDevice.isNotEmpty && newDevice != currDevice;

  final shouldInvalidate =
      forceRefresh || changedSchool || changedGrade || changedDevice;

  // If any identity-affecting field changes, invalidate guest so next ensure() re-logins
  if (shouldInvalidate) {
    await _sessionService.clearGuest();
  }

  // Persist provided profile updates (if any)
  if (schoolCode != null || gradeStr != null || deviceId != null) {
    await _sessionService.saveProfile(
      schoolCode: schoolCode,
      grade: gradeStr,
      deviceId: deviceId,
    );
  }

  // Try to reuse previously cached scoped guest creds for this profile (if any)
  final effectiveSchool =
      (newSchool != null && newSchool.isNotEmpty) ? newSchool : currSchool;
  final effectiveGrade =
      (newGrade != null && newGrade.isNotEmpty) ? newGrade : currGrade;
  final effectiveDevice =
      (newDevice != null && newDevice.isNotEmpty) ? newDevice : currDevice;
  if (effectiveSchool.isNotEmpty) {
    await _sessionService.applyScopedGuest(
      schoolCode: effectiveSchool,
      grade: effectiveGrade.isEmpty ? null : effectiveGrade,
      deviceId: effectiveDevice.isEmpty ? null : effectiveDevice,
    );
  }

  // Ensure we have a valid guest token for the (possibly new) school/grade/device
  await _guestAuthGate.ensure();
}

Future<void> _quickLogin() async {
  final profile = await _sessionService.loadProfile();

  final scode = (profile.schoolCode ?? '').trim().toUpperCase();
  if (scode.isEmpty) {
    throw ApiException(message: "Kode sekolah wajib diisi", code: 400);
  }

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

  final rawId = data['guest_id'];
  final guestId =
      (rawId is num) ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '');
  if (guestId == null) {
    throw ApiException(message: "guest_id tidak ditemukan/invalid", code: 500);
  }

  // Prefer token dari body jika ada, fallback ke header (x-guest-token/x-token)
  final tokenFromBody = (data['token'] ?? data['guest_token'])?.toString();
  final tokenFromHeader =
      response.headers?['x-guest-token'] ?? response.headers?['x-token'];
  final token = (tokenFromBody != null && tokenFromBody.isNotEmpty)
      ? tokenFromBody
      : (tokenFromHeader != null && tokenFromHeader.isNotEmpty)
          ? tokenFromHeader
          : null;
  if (token == null || token.isEmpty) {
    // BE tidak mengirim token; JANGAN menghapus token lama jika ada.
    final existingToken = await _sessionService.loadGuestToken();
    if (existingToken != null && existingToken.isNotEmpty) {
      await _sessionService.saveGuestAuth(
          token: existingToken, guestId: guestId);
      await _sessionService.saveScopedGuest(
        schoolCode: scode,
        grade: gradeStr,
        deviceId: normalizedDevice,
        guestId: guestId,
        token: existingToken,
      );
    } else {
      await _sessionService.saveGuest(guestId: guestId, token: null);
      await _sessionService.saveScopedGuest(
        schoolCode: scode,
        grade: gradeStr,
        deviceId: normalizedDevice,
        guestId: guestId,
        token: null,
      );
    }
    return;
  }

  await _sessionService.saveGuestAuth(token: token, guestId: guestId);
  await _sessionService.saveScopedGuest(
    schoolCode: scode,
    grade: gradeStr,
    deviceId: normalizedDevice,
    guestId: guestId,
    token: token,
  );
}
