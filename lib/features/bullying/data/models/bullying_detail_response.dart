class BullyingDetailResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  BullyingDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BullyingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BullyingDetailResponse(
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










