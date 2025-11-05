// lib/core/network/auth_header_provider.dart
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthHeaderProvider {
  final Future<String?> Function()? loadUserToken;
  final Future<String?> Function()? loadGuestToken;
  final Future<int?> Function()? loadGuestId;
  final Future<String?> Function()? loadCsrfToken;

  AuthHeaderProvider({
    this.loadUserToken,
    this.loadGuestToken,
    this.loadGuestId,
    this.loadCsrfToken,
  });

  Future<Map<String, String>> buildHeaders({bool asGuest = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // Hint for some CSRF middlewares/backends
      'X-Requested-With': 'XMLHttpRequest',
    };

    if (asGuest) {
      final token = await (loadGuestToken?.call());
      if (token != null && token.isNotEmpty) {
        headers['X-Guest-Token'] = token;
        // Duplikasi ke X-Token untuk kompatibilitas BE yang membaca header ini
        headers['X-Token'] = token;
      } else {
        // fallback: gunakan guest_id bila tersedia
        final gid = await (loadGuestId?.call());
        if (gid != null) {
          headers['X-Guest-Id'] = gid.toString();
        } else {
          // ignore: avoid_print
          print('[AuthHeaderProvider] warning: guest token missing');
        }
      }
      return headers;
    }

    final userToken = await (loadUserToken?.call());
    if (userToken != null && userToken.isNotEmpty) {
      // Send sessionid (and csrftoken if available) as Cookie header for Django session-based auth
      final csrf = await (loadCsrfToken?.call());
      final cookieParts = <String>['sessionid=$userToken'];
      if (csrf != null && csrf.isNotEmpty) {
        cookieParts.add('csrftoken=$csrf');
        headers['X-CSRFToken'] = csrf; // Must match csrftoken cookie
      }
      headers['Cookie'] = cookieParts.join('; ');
    }
    return headers;
  }

  Future<Map<String, String>> guestHeaders() => buildHeaders(asGuest: true);
}
