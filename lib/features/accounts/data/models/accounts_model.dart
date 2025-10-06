class AccountsModel {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AccountsModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.role,
    required this.createdAt,
    this.updatedAt,
  });

  factory AccountsModel.fromJson(Map<String, dynamic> json) {
    return AccountsModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}



