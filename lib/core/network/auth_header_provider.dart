// lib/core/network/auth_header_provider.dart
typedef AsyncStr = Future<String?> Function();
typedef AsyncInt = Future<int?> Function();

class AuthHeaderProvider {
  final AsyncStr? loadUserToken;
  final AsyncStr? loadGuestToken; // compat future token
  final AsyncInt? loadGuestId;
  final AsyncStr? loadDeviceId;

  AuthHeaderProvider({
    this.loadUserToken,
    this.loadGuestToken,
    this.loadGuestId,
    this.loadDeviceId,
  });

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (asGuest) {
      final gid = await (loadGuestId?.call());
      final dev = await (loadDeviceId?.call());
      if (gid != null) {
        headers["X-Guest-Id"] = gid.toString();
      }
      if (dev != null && dev.isNotEmpty) {
        headers["X-Device-Id"] = dev;
      }
      // compat: kalau suatu saat token tersedia
      final t = await (loadGuestToken?.call());
      if (t != null && t.isNotEmpty) {
        headers["X-Guest-Token"] = t;
      }
      return headers;
    }

    final bearer = await (loadUserToken?.call());
    if (bearer != null && bearer.isNotEmpty) {
      headers["Authorization"] = "Bearer $bearer";
    }
    return headers;
  }
}
