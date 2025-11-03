// lib/core/network/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? code;
  final Map<String, dynamic>? errors;

  ApiException({required this.message, this.code, this.errors});

  int? get statusCode => code; // <— tambahkan ini

  @override
  String toString() => "ApiException($code): $message";
}

class NetworkException extends ApiException {
  NetworkException(String msg): super(message: msg);
}
class TimeoutExceptionApi extends ApiException {
  TimeoutExceptionApi(String msg): super(message: msg);
}
