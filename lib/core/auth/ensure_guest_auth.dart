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
  if (schoolCode != null ||
      gradeStr != null ||
      deviceId != null ||
      forceRefresh) {
    await _sessionService.saveProfile(
      schoolCode: schoolCode,
      grade: gradeStr,
      deviceId: deviceId,
    );
    if (forceRefresh) {
      await _sessionService.clearGuest();
    }
  }

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

  final data = response.data;
  final rawId = data['guest_id'];
  final guestId =
      (rawId is num) ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '');
  if (guestId == null) {
    throw ApiException(message: "guest_id tidak ditemukan/invalid", code: 500);
  }

  final token = data['guest_token']?.toString();
  if (token == null || token.isEmpty) {
    throw ApiException(
      message: "guest_token tidak ditemukan/invalid",
      code: 500,
    );
  }

  await _sessionService.saveGuestAuth(token: token, guestId: guestId);
}
