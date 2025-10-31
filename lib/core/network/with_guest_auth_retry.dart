// lib/core/network/with_guest_auth_retry.dart

import 'package:sikap/core/auth/guest_auth_gate.dart';
import 'package:sikap/core/network/api_exception.dart';

Future<T> withGuestAuthRetry<T>(
  Future<T> Function() action,
  GuestAuthGate gate,
) async {
  try {
    return await action();
  } on ApiException catch (e) {
    if (e.statusCode == 401) {
      await gate.invalidate();
      await gate.ensure();
      return await action();
    }
    rethrow;
  }
}
