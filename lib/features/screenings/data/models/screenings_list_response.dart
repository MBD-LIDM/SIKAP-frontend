class ScreeningsListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  ScreeningsListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ScreeningsListResponse.fromJson(Map<String, dynamic> json) {
    return ScreeningsListResponse(
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









