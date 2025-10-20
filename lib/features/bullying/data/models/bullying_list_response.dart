class BullyingListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  BullyingListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BullyingListResponse.fromJson(Map<String, dynamic> json) {
    return BullyingListResponse(
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










