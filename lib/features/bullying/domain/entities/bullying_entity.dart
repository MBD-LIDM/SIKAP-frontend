class BullyingEntity {
  final String id;
  final String title;
  final String description;
  final String type;
  final String severity;
  final String status;
  final String reporterId;
  final String? targetId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BullyingEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.status,
    required this.reporterId,
    this.targetId,
    required this.createdAt,
    this.updatedAt,
  });
}










