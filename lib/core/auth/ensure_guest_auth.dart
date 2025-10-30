import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';

/// Ensures there's a guest token stored locally by performing a one-time
/// quick-login against the backend.
///
/// Behaviour:
/// - If 'guest_token' exists in storage, returns immediately.
/// - Else, POSTs to /api/accounts/guest/quick-login/ using ApiClient.
/// - Validates the success envelope and extracts guest_token and guest_id.
/// - Writes both values to secure storage.
/// - Prints a single debug line: "[GUEST] stored guest_id=<id>".
///
/// This function contains no UI and imports no dart:io to remain web-safe.
Future<void> ensureGuestAuthenticated() => _ensureGuestAuthenticated();

Future<void> _ensureGuestAuthenticated({
  FlutterSecureStorage? storage,
  ApiClient? apiClient,
}) async {
  final secure = storage ?? const FlutterSecureStorage();

  // 1) Fast path: already authenticated as guest
  final existing = await secure.read(key: 'guest_token');
  if (existing != null && existing.isNotEmpty) return;

  // 2) Request new guest credentials
  final api = apiClient ?? ApiClient();
  try {
    final resp = await api.post<Map<String, dynamic>>(
      '/api/accounts/guest/quick-login/',
      <String, dynamic>{},
      transform: (raw) => raw as Map<String, dynamic>,
    );

    final data = resp.data;
    final token = data['guest_token'];
    final id = data['guest_id'];

    if (token is! String || token.isEmpty || id == null) {
      throw ApiException(message: 'Envelope data tidak lengkap');
    }

    // Persist results; store id as string for consistency across platforms
    await secure.write(key: 'guest_token', value: token);
    await secure.write(key: 'guest_id', value: id.toString());

    // Single debug line per spec
    // ignore: avoid_print
    print('[GUEST] stored guest_id=${id.toString()}');
  } on ApiException {
    rethrow; // already well-formed for caller
  } catch (e) {
    // Normalize unexpected errors into ApiException for consistent handling
    throw ApiException(message: e.toString());
  }
}
