class ApiEnv {
  static const String baseUrl = "https://sikap-backend-production.up.railway.app";
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration readTimeout = Duration(seconds: 20);

  // Catatan: kalau butuh staging/dev, nanti jadikan per-flavor.
}
