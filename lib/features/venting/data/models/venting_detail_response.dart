class VentingDetailResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  VentingDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VentingDetailResponse.fromJson(Map<String, dynamic> json) {
    return VentingDetailResponse(
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










