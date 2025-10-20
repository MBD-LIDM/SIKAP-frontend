class WellbeingResourcesCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  WellbeingResourcesCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory WellbeingResourcesCreateResponse.fromJson(Map<String, dynamic> json) {
    return WellbeingResourcesCreateResponse(
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










