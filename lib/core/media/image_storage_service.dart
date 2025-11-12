import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:sikap/core/media/image_service_env.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

/// Data structure returned when requesting a signed upload URL.
class SignedUploadInfo {
  final String key; // blob key/path inside image service
  final Uri uploadUrl; // signed PUT URL
  final DateTime expiresAt;
  SignedUploadInfo({
    required this.key,
    required this.uploadUrl,
    required this.expiresAt,
  });
}

/// Attachment metadata used to register an uploaded blob with a bullying report.
class UploadedAttachmentMeta {
  final String key;
  final String mimeType;
  final String originalName;
  final int? sizeBytes;
  UploadedAttachmentMeta({
    required this.key,
    required this.mimeType,
    required this.originalName,
    this.sizeBytes,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'mime': mimeType,
        'original_name': originalName,
        if (sizeBytes != null) 'size': sizeBytes,
      };
}

/// Interface for image/blob storage abstraction.
abstract class IImageStorageService {
  Future<SignedUploadInfo> requestSignedUpload({
    required int reportId,
    required String originalName,
    required String mimeType,
    int? sizeBytes,
  });

  Future<void> putBytes({
    required SignedUploadInfo info,
    required List<int> bytes,
    required String mimeType,
  });

  Future<void> registerReportAttachments({
    required int reportId,
    required List<UploadedAttachmentMeta> attachments,
    bool asGuest = true,
  });
}

/// Production implementation depending on backend helper endpoints.
/// Backend must expose:
///   POST /api/media/sign-upload/ -> {key, upload_url, expires_at}
///   POST /api/bullying/report/{id}/attachments/register/ -> persist list
class ImageStorageService implements IImageStorageService {
  final ApiClient apiClient;
  final AuthHeaderProvider auth;
  ImageStorageService({required this.apiClient, required this.auth});

  @override
  Future<SignedUploadInfo> requestSignedUpload({
    required int reportId,
    required String originalName,
    required String mimeType,
    int? sizeBytes,
  }) async {
    final payload = {
      'report_id': reportId,
      'filename': originalName,
      'mime': mimeType,
      if (sizeBytes != null) 'size': sizeBytes,
    };
    // Choose appropriate headers (guest or staff). For now always guest; caller decides.
    final headers = await auth.guestHeaders();
    final resp = await apiClient.post<Map<String, dynamic>>(
      '/api/media/sign-upload/',
      payload,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: false,
    );
    final data = resp.data;
    if (data['key'] == null || data['upload_url'] == null) {
      throw ApiException(message: 'Signed upload response invalid');
    }
    return SignedUploadInfo(
      key: data['key'] as String,
      uploadUrl: Uri.parse(data['upload_url'] as String),
      expiresAt: DateTime.tryParse(data['expires_at'] ?? '') ??
          DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  @override
  Future<void> putBytes({
    required SignedUploadInfo info,
    required List<int> bytes,
    required String mimeType,
  }) async {
    // Direct PUT to signed URL (image service). No secret keys exposed.
    final r = await http.put(
      info.uploadUrl,
      headers: {
        'Content-Type': mimeType,
      },
      body: bytes,
    );
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw ApiException(code: r.statusCode, message: 'PUT blob gagal');
    }
  }

  @override
  Future<void> registerReportAttachments({
    required int reportId,
    required List<UploadedAttachmentMeta> attachments,
    bool asGuest = true,
  }) async {
    if (attachments.isEmpty) return;
    final headers = asGuest
        ? await auth.guestHeaders()
        : await auth.buildHeaders(asGuest: false);
    await apiClient.post(
      '/api/bullying/report/$reportId/attachments/register/',
      attachments.map((e) => e.toJson()).toList(),
      headers: headers,
      expectEnvelope: false,
    );
  }
}

/// Helper to read file bytes regardless of platform.
Future<List<int>> readFileBytes(String path) async {
  final f = File(path);
  return await f.readAsBytes();
}

/// Basic MIME inference by file extension.
String inferMime(String? filename) {
  final ext = filename?.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    case 'gif':
      return 'image/gif';
    case 'pdf':
      return 'application/pdf';
    default:
      return 'application/octet-stream';
  }
}

/// If Railway service disabled, this returns null so caller can fallback.
IImageStorageService? buildImageStorageServiceOrNull({
  required ApiClient apiClient,
  required AuthHeaderProvider auth,
}) {
  if (!ImageServiceEnv.useRailway) {
    return null;
  }
  return ImageStorageService(apiClient: apiClient, auth: auth);
}
