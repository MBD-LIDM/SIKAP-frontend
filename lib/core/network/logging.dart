import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Aktifkan via: --dart-define=LOG_HTTP=true
const bool kLogHttp = bool.fromEnvironment('LOG_HTTP', defaultValue: false);

String _safeJson(dynamic body) {
  try {
    if (body is String) return body;
    return const JsonEncoder.withIndent('  ').convert(body);
  } catch (_) {
    return '<non-json body>';
  }
}

void logHttp({
  required String phase,        // REQ | RES | ERR
  required String requestId,
  required String method,       // GET | POST | PATCH | DELETE | POST-MULTIPART
  required Uri uri,
  Map<String, String>? headers,
  dynamic body,
  int? status,
  Duration? duration,
  Object? error,
}) {
  if (!kLogHttp && !kDebugMode) return; // hanya log saat dev/diaktifkan

  final b = StringBuffer();
  b.writeln('[HTTP $phase] $method ${uri.toString()}');
  b.writeln('  id: $requestId');
  if (status != null) b.writeln('  status: $status');
  if (duration != null) b.writeln('  duration: ${duration.inMilliseconds} ms');

  if (headers != null && headers.isNotEmpty) {
    final redacted = Map<String, String>.from(headers);
    // Mask token
    if (redacted.containsKey('Authorization')) redacted['Authorization'] = '<redacted>';
    if (redacted.containsKey('X-Guest-Token')) redacted['X-Guest-Token'] = '<redacted>';
    if (redacted.containsKey('X-Token')) redacted['X-Token'] = '<redacted>';
    b.writeln('  headers: $redacted');
  }
  if (body != null) {
    b.writeln('  body:\n${_safeJson(body)}');
  }
  if (error != null) {
    b.writeln('  error: $error');
  }
  // ignore: avoid_print
  print(b.toString());
}
