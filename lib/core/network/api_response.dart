// lib/core/network/api_response.dart (FINAL)
class ApiResponse<T> {
  final T data;
  final int statusCode;
  final Map<String, String> headers;

  const ApiResponse(
    this.data, {
    this.statusCode = 200,
    this.headers = const {},
  });
}
