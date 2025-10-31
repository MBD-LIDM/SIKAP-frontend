import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sikap/core/auth/guest_auth_gate.dart';
import 'package:sikap/core/auth/session_service.dart';

class _FakeSessionService extends SessionService {
  String? _token;
  int? _guestId;

  @override
  Future<String?> loadGuestToken() async => _token;

  @override
  Future<int?> loadGuestId() async => _guestId;

  @override
  Future<void> saveGuestAuth({
    required String token,
    required int guestId,
  }) async {
    _token = token;
    _guestId = guestId;
  }

  @override
  Future<void> clearGuest() async {
    _token = null;
    _guestId = null;
  }
}

void main() {
  test('GuestAuthGate ensure is single-flight', () async {
    final session = _FakeSessionService();
    var invocationCount = 0;

    Future<void> quickLogin() async {
      invocationCount += 1;
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await session.saveGuestAuth(token: 'token-xyz', guestId: 42);
    }

    final gate = GuestAuthGate(session, quickLogin);

    await Future.wait([gate.ensure(), gate.ensure()]);

    expect(invocationCount, 1);
    expect(await session.loadGuestToken(), 'token-xyz');
    expect(await session.loadGuestId(), 42);
  });
}
