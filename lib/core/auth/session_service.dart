import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';

class SessionService {
  static const _kGuestToken = 'guest_token';
  static const _kGuestId = 'guest_id';

  final FlutterSecureStorage _storage;
  final ApiClient _api;

  SessionService({FlutterSecureStorage? storage, ApiClient? api})
      : _storage = storage ?? const FlutterSecureStorage(),
        _api = api ?? ApiClient();

  Future<String?> loadGuestToken() => _storage.read(key: _kGuestToken);
  Future<int?> loadGuestId() async {
    final raw = await _storage.read(key: _kGuestId);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> saveGuest({required String token, required int guestId}) async {
    await _storage.write(key: _kGuestToken, value: token);
    await _storage.write(key: _kGuestId, value: guestId.toString());
  }

  Future<void> clearGuest() async {
    await _storage.delete(key: _kGuestToken);
    await _storage.delete(key: _kGuestId);
  }

  Future<bool> ensureGuest() async {
    final t = await loadGuestToken();
    final id = await loadGuestId();
    if (t != null && t.isNotEmpty && id != null) return true;

    final res = await _api.post<Map<String, dynamic>>(
      "/api/accounts/guest/quick-login/",
      const {},                                // POSISIONAL body kedua
      transform: (raw) => raw as Map<String, dynamic>,
    );

    if (res.data['success'] != true) return false;

    final data = (res.data['data'] ?? {}) as Map<String, dynamic>;
    // BE kita sekarang konsisten pakai 'token'
    final token = data['token'] as String?;
    final guestId = (data['guest_id'] as num?)?.toInt();

    if (token == null || token.isEmpty || guestId == null) {
      throw ApiException(message: "Guest token/ID tidak ada di respons");
    }

    await saveGuest(token: token, guestId: guestId);
    return true;
  }
}
