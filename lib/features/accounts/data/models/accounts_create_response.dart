class AccountsCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AccountsCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AccountsCreateResponse.fromJson(Map<String, dynamic> json) {
    return AccountsCreateResponse(
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



