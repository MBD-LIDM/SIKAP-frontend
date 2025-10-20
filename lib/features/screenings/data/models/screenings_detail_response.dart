class ScreeningsDetailResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ScreeningsDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ScreeningsDetailResponse.fromJson(Map<String, dynamic> json) {
    return ScreeningsDetailResponse(
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










