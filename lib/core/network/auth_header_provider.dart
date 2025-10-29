typedef TokenLoader = Future<String?> Function();
typedef GuestLoader = Future<String?> Function();

class AuthHeaderProvider {
  final TokenLoader loadUserToken;
  final GuestLoader loadGuestToken;

  AuthHeaderProvider({required this.loadUserToken, required this.loadGuestToken});

  Future<Map<String, String>> build({bool asGuest = false}) async {
    final headers = <String, String>{};
    if (asGuest) {
      final guest = await loadGuestToken();
      if (guest != null && guest.isNotEmpty) headers["X-Guest-Token"] = guest;
    } else {
      final token = await loadUserToken();
      if (token != null && token.isNotEmpty) headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }
}
