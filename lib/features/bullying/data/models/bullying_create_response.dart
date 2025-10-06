class BullyingCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  BullyingCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BullyingCreateResponse.fromJson(Map<String, dynamic> json) {
    return BullyingCreateResponse(
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









