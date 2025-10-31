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
    final mp =
        MultipartClient.fromBytesSingle('audio', bytes, filename: filename);

    final resp = await multipartClient.postFile(
      endpoint: '/api/venting/analyze/',
      file: mp,
      fieldName: 'audio',
      headers: headers,
    );

    // Normalize backend response into UI-friendly shape expected by MoodCheckResultPage
    final raw = Map<String, dynamic>.from(resp.data as Map);
    return _normalizeBackendVentingResponse(raw);
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
    final mp =
        await MultipartClient.fromPathSingle('audio', path, filename: filename);

    final resp = await multipartClient.postFile(
      endpoint: '/api/venting/analyze/',
      file: mp,
      fieldName: 'audio',
      headers: headers,
    );

    // Normalize backend response into UI-friendly shape expected by MoodCheckResultPage
    final raw = Map<String, dynamic>.from(resp.data as Map);
    return _normalizeBackendVentingResponse(raw);
  }

  /// Convert backend response to a UI-friendly map.
  /// - Prefer `plutchik` (percentages summing ~100) and convert to `scores` with 0..1 values.
  /// - Set `primary_emotion` to the largest plutchik key and `primary_score` as fraction (0..1).
  /// - Fallback to legacy `emotions` if `plutchik` not present.
  Map<String, dynamic> _normalizeBackendVentingResponse(
      Map<String, dynamic> raw) {
    final out = <String, dynamic>{};

    // Pass-through common fields
    if (raw.containsKey('result_id')) out['result_id'] = raw['result_id'];
    if (raw.containsKey('disclaimer')) out['disclaimer'] = raw['disclaimer'];
    if (raw.containsKey('suggestion')) out['suggestion'] = raw['suggestion'];
    if (raw.containsKey('warning')) out['warning'] = raw['warning'];

    // Summary
    if (raw.containsKey('summary')) {
      out['summary'] = raw['summary']?.toString();
    }

    // Prefer plutchik set
    final plutchik = raw['plutchik'];
    Map<String, dynamic>? scores;
    if (plutchik is Map) {
      scores = <String, dynamic>{};
      plutchik.forEach((k, v) {
        if (v is num) {
          // backend provides percentages (0..100). Convert to fraction 0..1
          scores![k.toString()] = (v.toDouble() / 100.0).clamp(0.0, 1.0);
        }
      });
    }

    // Fallback to legacy emotions (sadness/anxiety/calmness)
    if (scores == null || scores.isEmpty) {
      final legacy = raw['emotions'];
      if (legacy is Map) {
        scores = <String, dynamic>{};
        legacy.forEach((k, v) {
          if (v is num) {
            scores![k.toString()] = (v.toDouble() / 100.0).clamp(0.0, 1.0);
          }
        });
      }
    }

    if (scores != null && scores.isNotEmpty) {
      out['scores'] = scores;
      // determine primary
      String? primary;
      double primaryScore = 0.0;
      scores.forEach((k, v) {
        final val = (v is num)
            ? v.toDouble()
            : double.tryParse(v?.toString() ?? '0') ?? 0.0;
        if (val > primaryScore) {
          primaryScore = val;
          primary = k;
        }
      });
      if (primary != null) {
        out['primary_emotion'] = primary;
        out['primary_score'] = primaryScore;
        // keep legacy keys for compatibility
        out['emotion'] = primary;
        out['score'] = primaryScore;
      }
    }

    return out;
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
          return analyzeAudioFromBytes(bytes,
              filename: name ?? 'audio.wav', asGuest: asGuest);
        }
      } catch (_) {
        // fallback di bawah
      }

      // Coba: langsung Uint8List
      if (audio is Uint8List) {
        return analyzeAudioFromBytes(audio,
            filename: 'audio.wav', asGuest: asGuest);
      }

      throw UnsupportedError(
        'Di Web, berikan PlatformFile (punya .bytes/.name) atau Uint8List.',
      );
    } else {
      // Coba: objek yang punya .path (XFile/File)
      try {
        final dyn = audio as dynamic;
        // Access path first — some types (e.g. File) have .path but not .name.
        final pathAny = dyn.path;
        if (pathAny is String && pathAny.isNotEmpty) {
          String? name;
          try {
            final nameAny = dyn.name;
            if (nameAny is String) name = nameAny;
          } catch (_) {
            // ignore: some objects don't expose .name
          }
          return analyzeAudioFromPath(pathAny,
              filename: name, asGuest: asGuest);
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
