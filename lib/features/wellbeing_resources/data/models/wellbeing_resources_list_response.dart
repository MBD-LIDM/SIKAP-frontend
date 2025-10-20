class WellbeingResourcesListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  WellbeingResourcesListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WellbeingResourcesListResponse.fromJson(Map<String, dynamic> json) {
    return WellbeingResourcesListResponse(
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










