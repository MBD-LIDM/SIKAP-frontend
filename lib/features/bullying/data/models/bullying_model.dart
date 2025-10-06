class BullyingModel {
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

  BullyingModel({
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

  factory BullyingModel.fromJson(Map<String, dynamic> json) {
    return BullyingModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      severity: json['severity'] ?? '',
      status: json['status'] ?? '',
      reporterId: json['reporter_id'] ?? '',
      targetId: json['target_id'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'severity': severity,
      'status': status,
      'reporter_id': reporterId,
      'target_id': targetId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}









