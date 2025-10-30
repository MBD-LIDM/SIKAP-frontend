class StudentSurveySubmitResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  StudentSurveySubmitResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StudentSurveySubmitResponse.fromJson(Map<String, dynamic> json) {
    return StudentSurveySubmitResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null ? null : Map<String, dynamic>.from(json['data'] as Map),
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
