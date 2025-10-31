// lib/core/network/auth_header_provider.dart

class AuthHeaderProvider {
  final Future<String?> Function()? loadUserToken;
  final Future<String?> Function()? loadGuestToken;
  final Future<int?> Function()? loadGuestId;

  AuthHeaderProvider({
    this.loadUserToken,
    this.loadGuestToken,
    this.loadGuestId,
  });

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (asGuest) {
      final guestToken = await (loadGuestToken?.call());
      if (guestToken != null && guestToken.isNotEmpty) {
        headers["X-Guest-Token"] = guestToken;
      }
      final guestId = await (loadGuestId?.call());
      if (guestId != null) {
        headers["X-Guest-Id"] = guestId.toString();
      }
      return headers;
    }

    final userToken = await (loadUserToken?.call());
    if (userToken != null && userToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $userToken";
    }
    return headers;
  }
}
