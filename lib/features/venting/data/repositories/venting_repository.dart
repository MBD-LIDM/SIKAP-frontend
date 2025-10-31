// lib/features/venting/data/repositories/venting_repository.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/network/multipart_client.dart';

class VentingRepository {
  final MultipartClient multipartClient;
  final AuthHeaderProvider auth;

  VentingRepository({
    required this.multipartClient,
    required this.auth,
  });

  /// === WEB: kirim dari bytes + filename (hasil FilePicker/XFile) ===
  Future<Map<String, dynamic>> analyzeAudioFromBytes(
    Uint8List bytes, {
    required String filename,
    bool asGuest = true,
  }) async {
  final headers = await auth.buildHeaders(asGuest: asGuest);
    final mp = MultipartClient.fromBytesSingle('file', bytes, filename: filename);

    final resp = await multipartClient.postFile(
      endpoint: '/api/venting/analyze/',
      file: mp,
      fieldName: 'file',
      headers: headers,
    );

    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// === MOBILE/DESKTOP: kirim dari path file lokal ===
  Future<Map<String, dynamic>> analyzeAudioFromPath(
    String path, {
    String? filename,
    bool asGuest = true,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('Gunakan analyzeAudioFromBytes() di Web');
    }

  final headers = await auth.buildHeaders(asGuest: asGuest);
    final mp = await MultipartClient.fromPathSingle('file', path, filename: filename);

    final resp = await multipartClient.postFile(
      endpoint: '/api/venting/analyze/',
      file: mp,
      fieldName: 'file',
      headers: headers,
    );

    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// === KOMPATIBILITAS: method lama yang UI kamu panggil ===
  /// - WEB: terima PlatformFile (punya .bytes/.name) atau langsung Uint8List.
  /// - MOBILE/DESKTOP: terima objek yang punya .path (XFile/File) atau String path.
  Future<Map<String, dynamic>> analyzeAudio(
    dynamic audio, {
    bool asGuest = true,
  }) async {
    if (kIsWeb) {
      // Coba: PlatformFile (file_picker) -> .bytes & .name
      try {
        final dyn = audio as dynamic;
        final Uint8List? bytes = dyn.bytes as Uint8List?;
        final String? name = dyn.name as String?;
        if (bytes != null) {
          return analyzeAudioFromBytes(bytes, filename: name ?? 'audio.wav', asGuest: asGuest);
        }
      } catch (_) {
        // fallback di bawah
      }

      // Coba: langsung Uint8List
      if (audio is Uint8List) {
        return analyzeAudioFromBytes(audio, filename: 'audio.wav', asGuest: asGuest);
      }

      throw UnsupportedError(
        'Di Web, berikan PlatformFile (punya .bytes/.name) atau Uint8List.',
      );
    } else {
      // Coba: objek yang punya .path (XFile/File)
      try {
        final dyn = audio as dynamic;
        final String? path = dyn.path as String?;
        final String? name = dyn.name as String?;
        if (path != null && path.isNotEmpty) {
          return analyzeAudioFromPath(path, filename: name, asGuest: asGuest);
        }
      } catch (_) {
        // fallback di bawah
      }

      // Coba: langsung path string
      if (audio is String && audio.isNotEmpty) {
        return analyzeAudioFromPath(audio, asGuest: asGuest);
      }

      throw UnsupportedError(
        'Di mobile/desktop, berikan objek dengan .path (XFile/File) atau String path.',
      );
    }
  }
}
