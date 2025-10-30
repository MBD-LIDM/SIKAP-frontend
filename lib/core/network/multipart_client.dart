// lib/core/network/multipart_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'api_env.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'logging.dart';

class MultipartClient {
  final http.Client _client;
  final Uri _base = Uri.parse(ApiEnv.baseUrl);

  MultipartClient({http.Client? client}) : _client = client ?? http.Client();

  /// Normalisasi penyusunan URL agar tidak double-slash.
  Uri _build(String endpoint) {
    final clean = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final basePath = _base.path.endsWith('/')
        ? _base.path
        : (_base.path.isEmpty ? '/' : '${_base.path}/');
    return _base.replace(path: '$basePath$clean');
  }

  /// Upload **1 file** (nama field default: 'file').
  Future<ApiResponse<dynamic>> postFile({
    required String endpoint,                 // e.g. '/api/venting/analyze/'
    required http.MultipartFile file,         // file tunggal
    Map<String, String>? headers,
    String fieldName = 'file',                // sesuaikan dg BE
    Map<String, String>? fields,              // extra form fields jika perlu
  }) async {
    final uri = _build(endpoint);
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final sw = Stopwatch()..start();

    final req = http.MultipartRequest('POST', uri);

    // Default headers untuk multipart: **jangan** set Content-Type di sini,
    // biarkan MultipartRequest yang set boundary-nya.
    final merged = <String, String>{
      'Accept': 'application/json',
      ...?headers,
    };
    req.headers.addAll(merged);

    if (fields != null && fields.isNotEmpty) {
      req.fields.addAll(fields);
    }

    // Pastikan nama field sesuai param 'fieldName'
    req.files.add(http.MultipartFile(
      fieldName,
      file.finalize(),
      file.length,
      filename: file.filename,
      contentType: file.contentType,
    ));

    logHttp(
      phase: 'REQ',
      requestId: requestId,
      method: 'POST-MULTIPART',
      uri: uri,
      headers: merged,
      body: 'multipart(1 file, field="$fieldName")',
    );

    try {
      final streamed = await req.send().timeout(ApiEnv.readTimeout);
      final resp = await http.Response.fromStream(streamed);
      sw.stop();

      logHttp(
        phase: 'RES',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        status: resp.statusCode,
        duration: sw.elapsed,
      );

      final json = jsonDecode(resp.body);
      if (resp.statusCode >= 200 &&
          resp.statusCode < 300 &&
          json is Map &&
          json['success'] == true) {
        return ApiResponse(json['data']);
      }
      throw ApiException(
        message:
            json is Map ? (json['message'] ?? 'Upload gagal') : 'Upload gagal',
        code: resp.statusCode,
        errors:
            json is Map ? (json['errors'] as Map<String, dynamic>?) : null,
      );
    } on SocketException {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: 'No internet',
        duration: sw.elapsed,
      );
      throw NetworkException('Tidak ada koneksi internet');
    } on TimeoutException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw TimeoutExceptionApi('Waktu koneksi habis');
    } on FormatException {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: 'Bad JSON',
        duration: sw.elapsed,
      );
      throw ApiException(message: 'Format respons tidak valid');
    }
  }

  /// Upload **banyak file** (nama field default: 'files[]').
  Future<ApiResponse<dynamic>> postFiles({
    required String endpoint,                  // e.g. '/api/bullying/report/123/attachments/'
    required List<http.MultipartFile> files,   // list file
    Map<String, String>? headers,
    String fieldName = 'files[]',              // sesuaikan dg BE
    Map<String, String>? fields,
  }) async {
    final uri = _build(endpoint);
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final sw = Stopwatch()..start();

    final req = http.MultipartRequest('POST', uri);

    final merged = <String, String>{
      'Accept': 'application/json',
      ...?headers,
    };
    req.headers.addAll(merged);

    if (fields != null && fields.isNotEmpty) {
      req.fields.addAll(fields);
    }

    for (final f in files) {
      req.files.add(http.MultipartFile(
        fieldName,
        f.finalize(),
        f.length,
        filename: f.filename,
        contentType: f.contentType,
      ));
    }

    logHttp(
      phase: 'REQ',
      requestId: requestId,
      method: 'POST-MULTIPART',
      uri: uri,
      headers: merged,
      body: 'multipart(${files.length} files, field="$fieldName")',
    );

    try {
      final streamed = await req.send().timeout(ApiEnv.readTimeout);
      final resp = await http.Response.fromStream(streamed);
      sw.stop();

      logHttp(
        phase: 'RES',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        status: resp.statusCode,
        duration: sw.elapsed,
      );

      final json = jsonDecode(resp.body);
      if (resp.statusCode >= 200 &&
          resp.statusCode < 300 &&
          json is Map &&
          json['success'] == true) {
        return ApiResponse(json['data']);
      }
      throw ApiException(
        message:
            json is Map ? (json['message'] ?? 'Upload gagal') : 'Upload gagal',
        code: resp.statusCode,
        errors:
            json is Map ? (json['errors'] as Map<String, dynamic>?) : null,
      );
    } on SocketException {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: 'No internet',
        duration: sw.elapsed,
      );
      throw NetworkException('Tidak ada koneksi internet');
    } on TimeoutException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw TimeoutExceptionApi('Waktu koneksi habis');
    } on FormatException {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST-MULTIPART',
        uri: uri,
        error: 'Bad JSON',
        duration: sw.elapsed,
      );
      throw ApiException(message: 'Format respons tidak valid');
    }
  }

  // ===== Helpers untuk bikin MultipartFile =====

  /// Dari bytes → satu file (nama field bebas; default gunakan di postFile/postFiles)
  static http.MultipartFile fromBytesSingle(
    String fieldName,
    List<int> bytes, {
    required String filename,
  }) {
    final mime = lookupMimeType(filename) ?? 'application/octet-stream';
    return http.MultipartFile.fromBytes(
      fieldName,
      bytes,
      filename: filename,
      contentType: MediaType.parse(mime),
    );
  }

  /// Dari path (Android/iOS) → satu file.
  static Future<http.MultipartFile> fromPathSingle(
    String fieldName,
    String path, {
    String? filename,
  }) async {
    final mime = lookupMimeType(path) ?? 'application/octet-stream';
    return http.MultipartFile.fromPath(
      fieldName,
      path,
      filename: filename,
      contentType: MediaType.parse(mime),
    );
  }

  /// Dari bytes → **untuk koleksi** file (nama field akan di-set saat add ke request).
  static http.MultipartFile fromBytes(
    String name,
    List<int> bytes, {
    required String filename,
  }) {
    final mime = lookupMimeType(filename) ?? 'application/octet-stream';
    return http.MultipartFile.fromBytes(
      name,
      bytes,
      filename: filename,
      contentType: MediaType.parse(mime),
    );
  }

  /// Dari path → **untuk koleksi** file.
  static Future<http.MultipartFile> fromPath(
    String name,
    String path, {
    String? filename,
  }) async {
    final mime = lookupMimeType(path) ?? 'application/octet-stream';
    return http.MultipartFile.fromPath(
      name,
      path,
      filename: filename,
      contentType: MediaType.parse(mime),
    );
  }
}
