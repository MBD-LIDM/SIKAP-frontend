import 'package:flutter_test/flutter_test.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

void main() {
  test('guestHeaders returns X-Guest-Token when available', () async {
    final provider = AuthHeaderProvider(
      loadGuestToken: () async => 'guest-token-123',
    );

    final headers = await provider.guestHeaders();

    expect(headers['X-Guest-Token'], 'guest-token-123');
    expect(headers['Accept'], 'application/json');
    expect(headers['Content-Type'], 'application/json');
  });
}
