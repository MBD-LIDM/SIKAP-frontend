class AccountsEntity {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AccountsEntity({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.role,
    required this.createdAt,
    this.updatedAt,
  });
}



