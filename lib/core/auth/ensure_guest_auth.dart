// lib/core/auth/ensure_guest_auth.dart

import 'package:sikap/core/auth/guest_auth_gate.dart';
import 'package:sikap/core/auth/session_service.dart';

final GuestAuthGate _guestAuthGate = GuestAuthGate();

Future<void> ensureGuestAuthenticated({
  String? schoolCode,
  String? gradeStr,
  String? deviceId,
  bool forceRefresh = false,
  SessionService? sessionOverride,
}) {
  final session = sessionOverride ?? SessionService();
  return _guestAuthGate.ensure(
    session: session,
    schoolCode: schoolCode,
    gradeStr: gradeStr,
    deviceId: deviceId,
    forceRefresh: forceRefresh,
  );
}
