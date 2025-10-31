// lib/core/auth/guest_auth_gate.dart

import 'package:sikap/core/auth/session_service.dart';

class GuestAuthGate {
  GuestAuthGate(this._session, this._quickLogin);

  final SessionService _session;
  final Future<void> Function() _quickLogin;
  Future<void>? _inFlight;

  SessionService get session => _session;

  Future<void> ensure() async {
    final token = await _session.loadGuestToken();
    if (token != null && token.isNotEmpty) {
      return;
    }
    _inFlight ??= _quickLogin();
    try {
      await _inFlight;
    } finally {
      _inFlight = null;
    }
  }

  Future<void> invalidate() => _session.clearGuest();
}
