class AccountsListResponse {
  final bool success;
  final String message;
  final List<dynamic>? data;

  AccountsListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AccountsListResponse.fromJson(Map<String, dynamic> json) {
    return AccountsListResponse(
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



