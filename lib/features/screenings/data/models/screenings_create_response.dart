class ScreeningsCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ScreeningsCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ScreeningsCreateResponse.fromJson(Map<String, dynamic> json) {
    return ScreeningsCreateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}










