// lib/core/network/auth_header_provider.dart

class AuthHeaderProvider {
  final Future<String?> Function()? loadUserToken;
  final Future<String?> Function()? loadGuestToken;

  AuthHeaderProvider({
    this.loadUserToken,
    this.loadGuestToken,
  });

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (asGuest) {
      final token = await (loadGuestToken?.call());
      if (token != null && token.isNotEmpty) {
        headers['X-Guest-Token'] = token;
      } else {
        // ignore: avoid_print
        print('[AuthHeaderProvider] warning: guest token missing');
      }
      return headers;
    }

    final userToken = await (loadUserToken?.call());
    if (userToken != null && userToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $userToken';
    }
    return headers;
  }

  Future<Map<String, String>> guestHeaders() => buildHeaders(asGuest: true);
}
