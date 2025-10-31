// lib/core/network/auth_header_provider.dart
class AuthHeaderProvider {
  final Future<String?> Function()? loadUserToken;
  final Future<String?> Function()? loadGuestToken;
  final Future<int?> Function()? loadGuestId;   // ⬅️ tambahkan

  AuthHeaderProvider({this.loadUserToken, this.loadGuestToken, this.loadGuestId});

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (asGuest) {
      final t = await (loadGuestToken?.call());
      if (t != null && t.isNotEmpty) {
        headers["X-Guest-Token"] = t;
        return headers;
      }
      // fallback pakai guest_id kalau token tidak ada
      final gid = await (loadGuestId?.call());
      if (gid != null) {
        headers["X-Guest-Id"] = gid.toString();
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
