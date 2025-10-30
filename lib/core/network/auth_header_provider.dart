class AuthHeaderProvider {
  final Future<String?> Function()? loadUserToken;
  final Future<String?> Function()? loadGuestToken;

  AuthHeaderProvider({this.loadUserToken, this.loadGuestToken});

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (asGuest) {
      final t = await (loadGuestToken?.call());
      if (t != null && t.isNotEmpty) {
        headers["X-Guest-Token"] = t;
      }
      return headers;
    }
    final userT = await (loadUserToken?.call());
    if (userT != null && userT.isNotEmpty) {
      headers["Authorization"] = "Bearer $userT";
    }
    return headers;
  }
}
