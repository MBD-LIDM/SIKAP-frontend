class BullyingCreateResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  BullyingCreateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BullyingCreateResponse.fromJson(Map<String, dynamic> json) {
    return BullyingCreateResponse(
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

  int? get reportId {
    final value = data == null ? null : data!['report_id'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  String? get timestampIso8601 {
    final value = data == null ? null : data!['timestamp'];
    if (value is String) return value;
    return value?.toString();
  }
}










