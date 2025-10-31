// lib/core/network/api_client.dart
// FIX: default JSON headers + dukung endpoint tanpa envelope (expectEnvelope=false).
// Tambah logging ringan biar gampang trace.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/api_env.dart';

const bool kApiDebugLog =
    bool.fromEnvironment('API_HTTP_DEBUG', defaultValue: false);

Map<String, dynamic>? _tryDecodeJson(String s) {
  try {
    final d = s.isEmpty ? null : (jsonDecode(s) as Object?);
    return (d is Map<String, dynamic>) ? d : null;
  } catch (_) {
    return null;
  }
}

T _handle<T>(
  http.Response res, {
  bool expectEnvelope = true,
  T Function(dynamic raw)? transform,
}) {
  final status = res.statusCode;
  final bodyStr = res.body;
  final jsonMap = _tryDecodeJson(bodyStr);

  if (status >= 200 && status < 300) {
    final raw = expectEnvelope ? (jsonMap?['data']) : (jsonMap ?? bodyStr);
    return (transform != null) ? transform(raw) : raw as T;
  }

  // Kumpulkan pesan & field errors dari BE
  String msg = 'HTTP $status';
  Map<String, dynamic>? errs;

  if (jsonMap != null) {
    // pola umum DRF: {"detail": "..."} atau field: {"school_id":["Invalid school."]}
    if (jsonMap['detail'] is String) msg = jsonMap['detail'] as String;
    // if envelope error: {"success":false,"message":"...","errors":{...}}
    if (jsonMap['message'] is String) msg = jsonMap['message'] as String;
    if (jsonMap['errors'] is Map<String, dynamic>)
      errs = Map<String, dynamic>.from(jsonMap['errors']);
    // kalau bukan "errors", anggap seluruh map adalah field errors
    errs ??= Map<String, dynamic>.from(jsonMap);
  }

  throw ApiException(message: msg, code: status, errors: errs);
}

class ApiResponse<T> {
  final T data;
  final int? status;
  final Map<String, String>? headers;
  ApiResponse(this.data, {this.status, this.headers});
}

class ApiClient {
  ApiClient({http.Client? httpClient}) : _client = httpClient ?? http.Client();

  final http.Client _client;

  Uri _u(String endpoint) => Uri.parse("${ApiEnv.baseUrl}$endpoint");

  void _logReq(String method, Uri url, Map<String, String> headers) {
    if (!kApiDebugLog) return;
    final token = headers['X-Guest-Token'];
    final prefix =
        (token == null || token.isEmpty) ? '-' : token.substring(0, 6);
    // ignore: avoid_print
    print('[API] $method $url headers=${headers.keys} token=$prefix');
  }

  ApiResponse<T> _handle<T>(
    http.Response resp, {
    T Function(dynamic)? transform,
    bool expectEnvelope = true,
  }) {
    final contentType = resp.headers['content-type'] ?? '';

    dynamic decoded;
    try {
      decoded = resp.bodyBytes.isEmpty ? null : jsonDecode(resp.body);
    } catch (_) {
      decoded = null;
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      // Guard: HTML error page (e.g., 404/500 from proxy)
      if (contentType.contains('text/html')) {
        throw ApiException(
          message: "HTTP ${resp.statusCode} (HTML error page)",
          code: resp.statusCode,
        );
      }
      String msg = resp.reasonPhrase ?? "HTTP ${resp.statusCode}";
      Map<String, dynamic>? errs;
      if (decoded is Map) {
        if (decoded['message'] is String) msg = decoded['message'];
        if (decoded['detail'] is String) msg = decoded['detail'];
        if (decoded['errors'] is Map)
          errs = Map<String, dynamic>.from(decoded['errors']);
      }
      throw ApiException(message: msg, code: resp.statusCode, errors: errs);
    }

    if (!expectEnvelope) {
      final data = (transform != null) ? transform(decoded) : decoded as T;
      return ApiResponse<T>(data,
          status: resp.statusCode, headers: resp.headers);
    }

    if (decoded is! Map || decoded['success'] != true) {
      throw ApiException(message: "Envelope tidak valid / success != true");
    }
    final raw = decoded['data'];
    final data = (transform != null) ? transform(raw) : raw as T;
    return ApiResponse<T>(data, status: resp.statusCode, headers: resp.headers);
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
    bool expectEnvelope = true,
  }) async {
    final uri = _u(endpoint);
    final base = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final finalHeaders = {...base, if (headers != null) ...headers};
    _logReq('GET', uri, finalHeaders);
    final r = await _client.get(uri, headers: finalHeaders);
    return _handle<T>(r, transform: transform, expectEnvelope: expectEnvelope);
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
    bool expectEnvelope = true,
  }) async {
    final uri = _u(endpoint);
    final base = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final finalHeaders = {...base, if (headers != null) ...headers};
    final encodedBody = body is String ? body : jsonEncode(body);
    _logReq('POST', uri, finalHeaders);
    final r = await _client.post(
      uri,
      headers: finalHeaders,
      body: encodedBody,
    );
    return _handle<T>(r, transform: transform, expectEnvelope: expectEnvelope);
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
    bool expectEnvelope = true,
  }) async {
    final uri = _u(endpoint);
    final base = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final finalHeaders = {...base, if (headers != null) ...headers};
    final encodedBody = body is String ? body : jsonEncode(body);
    _logReq('PATCH', uri, finalHeaders);
    final r = await _client.patch(
      uri,
      headers: finalHeaders,
      body: encodedBody,
    );
    return _handle<T>(r, transform: transform, expectEnvelope: expectEnvelope);
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
    bool expectEnvelope = true,
  }) async {
    final uri = _u(endpoint);
    final base = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final finalHeaders = {...base, if (headers != null) ...headers};
    _logReq('DELETE', uri, finalHeaders);
    final r = await _client.delete(uri, headers: finalHeaders);
    return _handle<T>(r, transform: transform, expectEnvelope: expectEnvelope);
  }
}
