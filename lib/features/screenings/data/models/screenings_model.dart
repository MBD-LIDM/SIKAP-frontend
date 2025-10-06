class ScreeningsModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final List<Map<String, dynamic>> questions;
  final String status;
  final String userId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? results;

  ScreeningsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questions,
    required this.status,
    required this.userId,
    required this.createdAt,
    this.completedAt,
    this.results,
  });

  factory ScreeningsModel.fromJson(Map<String, dynamic> json) {
    return ScreeningsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      status: json['status'] ?? '',
      userId: json['user_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      results: json['results'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'questions': questions,
      'status': status,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'results': results,
    };
  }
}









