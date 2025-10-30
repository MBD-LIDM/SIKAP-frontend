/// lib/core/network/api_env.dart
class ApiEnv {
  // Default environment
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'production');

  // URLs per environment
  static const Map<String, String> _baseUrls = {
    'production': 'https://sikap-backend-production.up.railway.app',
    'staging': 'https://sikap-backend-dev.up.railway.app',
    'development': 'http://localhost:8000', // local Django for web development
  };

  /// Base URL yang dipakai oleh aplikasi
  static String get baseUrl {
    return _baseUrls[_env] ?? _baseUrls['production']!;
  }

  /// Waktu tunggu koneksi & pembacaan data
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration readTimeout = Duration(seconds: 20);

  /// Untuk debugging: print environment aktif
  static void printActiveEnv() {
    // ignore: avoid_print
    print("Active API Environment: $_env → $baseUrl");
  }
}
