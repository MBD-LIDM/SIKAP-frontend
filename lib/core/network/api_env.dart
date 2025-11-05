/// lib/core/network/api_env.dart
class ApiEnv {
  // Baca ENV dari --dart-define (production | staging | development)
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'production');

  // NOTE: tanpa trailing slash agar tidak jadi double // saat join endpoint
  static const Map<String, String> _baseUrls = {
    'production': 'https://sikap-backend-dev.up.railway.app',
    'staging': 'https://sikap-backend-dev.up.railway.app',
    'development': 'http://127.0.0.1:8000',
  };

  static String get baseUrl => _baseUrls[_env] ?? _baseUrls['production']!;

  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration readTimeout = Duration(seconds: 20);

  static void printActiveEnv() {
    // ignore: avoid_print
    print("Active API Environment: $_env → $baseUrl");
  }
}
