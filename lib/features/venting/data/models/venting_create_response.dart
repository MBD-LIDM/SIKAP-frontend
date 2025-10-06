class VentingCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  VentingCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VentingCreateResponse.fromJson(Map<String, dynamic> json) {
    return VentingCreateResponse(
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









