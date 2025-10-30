class StudentSurveyListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  StudentSurveyListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StudentSurveyListResponse.fromJson(Map<String, dynamic> json) {
    return StudentSurveyListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null ? null : List<dynamic>.from(json['data'] as List),
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
