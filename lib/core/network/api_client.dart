import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_env.dart';
import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    final uri = Uri.parse("${ApiEnv.baseUrl}$endpoint");
    try {
      final resp = await _client
          .get(uri, headers: _withDefaults(headers))
          .timeout(ApiEnv.readTimeout);

      return _handle<T>(resp, transform: transform);
    } on SocketException {
      throw NetworkException("Tidak ada koneksi internet");
    } on HttpException {
      throw NetworkException("Gagal koneksi ke server");
    } on FormatException {
      throw ApiException(message: "Format respons tidak valid");
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    final uri = Uri.parse("${ApiEnv.baseUrl}$endpoint");
    try {
      final resp = await _client
          .post(uri, headers: _withDefaults(headers), body: jsonEncode(body))
          .timeout(ApiEnv.readTimeout);

      return _handle<T>(resp, transform: transform);
    } on SocketException {
      throw NetworkException("Tidak ada koneksi internet");
    } on FormatException {
      throw ApiException(message: "Format respons tidak valid");
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
    T Function(dynamic json)? transform,
  }) async {
    final uri = Uri.parse("${ApiEnv.baseUrl}$endpoint");
    try {
      final resp = await _client
          .patch(uri, headers: _withDefaults(headers), body: jsonEncode(body))
          .timeout(ApiEnv.readTimeout);

      return _handle<T>(resp, transform: transform);
    } on SocketException {
      throw NetworkException("Tidak ada koneksi internet");
    } on FormatException {
      throw ApiException(message: "Format respons tidak valid");
    }
  }

  Map<String, String> _withDefaults(Map<String, String>? headers) => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        ...?headers,
      };

  ApiResponse<T> _handle<T>(http.Response resp, {T Function(dynamic)? transform}) {
    final decoded = jsonDecode(resp.body);

    // Error dari server (400–500) → bungkus jadi ApiException dengan envelope
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      final msg = decoded is Map ? (decoded["message"] ?? resp.reasonPhrase ?? "Server error") : "Server error";
      final errs = decoded is Map ? (decoded["errors"] as Map<String, dynamic>?) : null;
      throw ApiException(message: msg, code: resp.statusCode, errors: errs);
    }

    // Sukses tapi bukan envelope → tolak, supaya konsisten
    if (decoded is! Map || !decoded.containsKey("success")) {
      throw ApiException(message: "Envelope tidak ditemukan pada respons");
    }

    if (decoded["success"] != true) {
      throw ApiException(message: decoded["message"] ?? "Gagal", code: resp.statusCode, errors: decoded["errors"]);
    }

    final raw = decoded["data"];
    final data = (transform != null) ? transform(raw) : raw as T;
    return ApiResponse<T>(data);
  }
}
