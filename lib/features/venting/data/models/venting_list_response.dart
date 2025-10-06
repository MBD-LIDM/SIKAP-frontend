class VentingListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  VentingListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VentingListResponse.fromJson(Map<String, dynamic> json) {
    return VentingListResponse(
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









