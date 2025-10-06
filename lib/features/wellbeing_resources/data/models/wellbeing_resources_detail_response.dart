class WellbeingResourcesDetailResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  WellbeingResourcesDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WellbeingResourcesDetailResponse.fromJson(Map<String, dynamic> json) {
    return WellbeingResourcesDetailResponse(
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









