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
      
      // Mask token for logging
      final maskedToken = userToken.length > 20
          ? '${userToken.substring(0, 10)}...${userToken.substring(userToken.length - 4)}'
          : '***';
      print('[AUTH_HEADER] Building staff headers - sessionId: $maskedToken');
      
      final cookieParts = <String>['sessionid=$userToken'];
      if (csrf != null && csrf.isNotEmpty) {
        cookieParts.add('csrftoken=$csrf');
        headers['X-CSRFToken'] = csrf; // Must match csrftoken cookie
        
        // Mask CSRF for logging
        final maskedCsrf = csrf.length > 20
            ? '${csrf.substring(0, 8)}...${csrf.substring(csrf.length - 4)}'
            : '***';
        print('[AUTH_HEADER] CSRF token present: $maskedCsrf');
      } else {
        print('[AUTH_HEADER] ⚠️ WARNING: CSRF token is missing!');
      }
      
      final cookieHeader = cookieParts.join('; ');
      headers['Cookie'] = cookieHeader;
      
      // Log final Cookie header format (masked)
      final maskedCookie = cookieHeader.length > 40
          ? '${cookieHeader.substring(0, 20)}...${cookieHeader.substring(cookieHeader.length - 15)}'
          : '***';
      print('[AUTH_HEADER] Cookie header format: $maskedCookie');
    } else {
      print('[AUTH_HEADER] ⚠️ WARNING: User token is null or empty!');
      print('[AUTH_HEADER] ⚠️ Staff authentication will fail - no Cookie header will be sent');
    }
    return headers;
  }

  Future<Map<String, String>> guestHeaders() => buildHeaders(asGuest: true);
}
