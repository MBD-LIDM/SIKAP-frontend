/// Environment flags for Railway Image Service integration.
/// Use --dart-define to set these at build time.
/// Example:
///   flutter run --dart-define=USE_RAILWAY_IMAGE_SERVICE=true \
///               --dart-define=IMAGE_SERVICE_BASE_URL=https://img.yourdomain.app
///
/// When USE_RAILWAY_IMAGE_SERVICE=false the app will fallback to legacy multipart
/// POST /api/bullying/report/{id}/attachments/ flow.
class ImageServiceEnv {
  static const bool useRailway = bool.fromEnvironment(
    'USE_RAILWAY_IMAGE_SERVICE',
    defaultValue: true,
  );

  /// Base URL of the deployed railway-image-service (no trailing slash).
  static const String baseUrl = String.fromEnvironment(
    'IMAGE_SERVICE_BASE_URL',
    defaultValue: '',
  );
}
