// lib/core/network/api_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_env.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'logging.dart';

class ApiClient {
  final http.Client _client;
  final Uri _base = Uri.parse(ApiEnv.baseUrl);

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Normalisasi penyusunan URL agar tidak pernah double-slash.
  Uri _build(String endpoint) {
    final clean = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final basePath = _base.path.endsWith('/')
        ? _base.path
        : (_base.path.isEmpty ? '/' : '${_base.path}/');
    return _base.replace(path: '$basePath$clean');
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    // debug kecil untuk memastikan ter-load
    // ignore: avoid_print
    print("[DEBUG] ApiClient loaded successfully");

    final uri = _build(endpoint);
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final mergedHeaders = _withDefaults(headers, requestId: requestId);
    final sw = Stopwatch()..start();

    try {
      logHttp(
        phase: 'REQ',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        headers: mergedHeaders,
      );
      final resp = await _client
          .get(uri, headers: mergedHeaders)
          .timeout(ApiEnv.readTimeout);

      sw.stop();
      logHttp(
        phase: 'RES',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        status: resp.statusCode,
        duration: sw.elapsed,
      );

      return _handle<T>(resp, transform: transform);
    } on TimeoutException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw TimeoutExceptionApi('Waktu koneksi habis');
    } on SocketException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw NetworkException("Tidak ada koneksi internet");
    } on HttpException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw NetworkException("Gagal koneksi ke server");
    } on FormatException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'GET',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw ApiException(message: "Format respons tidak valid");
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    final uri = _build(endpoint);
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final mergedHeaders = _withDefaults(headers, requestId: requestId);
    final sw = Stopwatch()..start();

    try {
      logHttp(
        phase: 'REQ',
        requestId: requestId,
        method: 'POST',
        uri: uri,
        headers: mergedHeaders,
        body: body,
      );

      final resp = await _client
          .post(uri, headers: mergedHeaders, body: jsonEncode(body))
          .timeout(ApiEnv.readTimeout);

      sw.stop();
      logHttp(
        phase: 'RES',
        requestId: requestId,
        method: 'POST',
        uri: uri,
        status: resp.statusCode,
        duration: sw.elapsed,
      );

      return _handle<T>(resp, transform: transform);
    } on TimeoutException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw TimeoutExceptionApi('Waktu koneksi habis');
    } catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'POST',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      rethrow;
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    final uri = _build(endpoint);
    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final mergedHeaders = _withDefaults(headers, requestId: requestId);
    final sw = Stopwatch()..start();

    try {
      logHttp(
        phase: 'REQ',
        requestId: requestId,
        method: 'PATCH',
        uri: uri,
        headers: mergedHeaders,
        body: body,
      );

      final resp = await _client
          .patch(uri, headers: mergedHeaders, body: jsonEncode(body))
          .timeout(ApiEnv.readTimeout);

      sw.stop();
      logHttp(
        phase: 'RES',
        requestId: requestId,
        method: 'PATCH',
        uri: uri,
        status: resp.statusCode,
        duration: sw.elapsed,
      );

      return _handle<T>(resp, transform: transform);
    } on TimeoutException catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'PATCH',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      throw TimeoutExceptionApi('Waktu koneksi habis');
    } catch (e) {
      sw.stop();
      logHttp(
        phase: 'ERR',
        requestId: requestId,
        method: 'PATCH',
        uri: uri,
        error: e,
        duration: sw.elapsed,
      );
      rethrow;
    }
  }

  Map<String, String> _withDefaults(
    Map<String, String>? headers, {
    required String requestId,
  }) =>
      {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-Request-Id": requestId, // korelasi dengan logs Railway
        ...?headers,
      };

  ApiResponse<T> _handle<T>(
    http.Response resp, {
    T Function(dynamic)? transform,
  }) {
    final decoded = jsonDecode(resp.body);

    // Error HTTP
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      final msg = decoded is Map
          ? (decoded["message"] ?? resp.reasonPhrase ?? "Server error")
          : "Server error";
      final errs =
          decoded is Map ? (decoded["errors"] as Map<String, dynamic>?) : null;
      throw ApiException(message: msg, code: resp.statusCode, errors: errs);
    }

    // Envelope {success, message, data}
    if (decoded is! Map || decoded["success"] != true) {
      throw ApiException(message: "Envelope tidak ditemukan atau success=false");
    }

    final raw = decoded["data"];
    final data = (transform != null) ? transform(raw) : raw as T;
    return ApiResponse<T>(data);
  }
}
