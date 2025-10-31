// lib/core/auth/guest_auth_gate.dart

import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';

typedef _QuickLoginFn = Future<Map<String, dynamic>> Function(
  Map<String, dynamic> payload,
);

class GuestAuthGate {
  GuestAuthGate();

  Future<void>? _inFlight;

  Future<void> ensure({
    SessionService? session,
    String? schoolCode,
    String? gradeStr,
    String? deviceId,
    bool forceRefresh = false,
    _QuickLoginFn? quickLogin,
  }) async {
    final targetSession = session ?? SessionService();
    if (!forceRefresh) {
      final existingId = await targetSession.loadGuestId();
      final existingToken = await targetSession.loadGuestToken();
      if (existingId != null &&
          existingToken != null &&
          existingToken.isNotEmpty) {
        return;
      }
    }

    final ongoing = _inFlight;
    if (ongoing != null) {
      return ongoing;
    }

    final future = _performQuickLogin(
      session: targetSession,
      schoolCode: schoolCode,
      gradeStr: gradeStr,
      deviceId: deviceId,
      quickLogin: quickLogin ?? _defaultQuickLogin,
    ).whenComplete(() {
      _inFlight = null;
    });

    _inFlight = future;
    return future;
  }

  Future<void> _performQuickLogin({
    required SessionService session,
    required _QuickLoginFn quickLogin,
    String? schoolCode,
    String? gradeStr,
    String? deviceId,
  }) async {
    final profile = await session.loadProfile();

    // Lengkapi deviceId
    final normalizedDevice = (deviceId ?? profile.deviceId ?? '').trim();
    final device =
        normalizedDevice.isEmpty ? const Uuid().v4() : normalizedDevice;

    // Validasi school_code
    final scode =
        (schoolCode ?? profile.schoolCode ?? '').trim().toUpperCase();
    if (scode.isEmpty) {
      throw ApiException(message: "Kode sekolah wajib diisi", code: 400);
    }

    // Parse grade
    final gstr = (gradeStr ?? profile.grade ?? '').trim();
    final grade = int.tryParse(gstr);
    if (grade == null) {
      throw ApiException(message: "Grade harus numerik (10/11/12).", code: 400);
    }

    await session.saveProfile(
      schoolCode: scode,
      grade: gstr,
      deviceId: device,
    );

    final payload = {
      "school_code": scode,
      "grade": grade,
      "device_id": device,
    };

    final map = await quickLogin(payload);

    final rawId = map['guest_id'];
    final guestId =
        (rawId is num) ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '');
    if (guestId == null) {
      throw ApiException(message: "guest_id tidak ditemukan/invalid", code: 500);
    }

    final tokenCandidate =
        map['guest_token'] ?? map['token'] ?? map['guestToken'];
    final guestToken = tokenCandidate?.toString();
    if (guestToken == null || guestToken.isEmpty) {
      throw ApiException(
        message: "guest_token tidak ditemukan/invalid",
        code: 500,
      );
    }

    await session.saveGuest(guestId: guestId, token: guestToken);
    // ignore: avoid_print
    print(
      "[GUEST] stored guest_id=$guestId token=${_maskToken(guestToken)} "
      "(device=$device, school=$scode, grade=$grade)",
    );
  }

  static Future<Map<String, dynamic>> _defaultQuickLogin(
    Map<String, dynamic> payload,
  ) async {
    final api = ApiClient();
    final response = await api.post<Map<String, dynamic>>(
      "/api/accounts/student/quick-login/",
      payload,
      headers: const {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      expectEnvelope: false,
      transform: (raw) => Map<String, dynamic>.from(raw as Map),
    );
    return response.data;
  }

  static String _maskToken(String token, {int head = 6, int tail = 4}) {
    if (token.length <= head + tail) {
      return token;
    }
    return '${token.substring(0, head)}…${token.substring(token.length - tail)}';
  }
}
