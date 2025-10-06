class ScreeningsEntity {
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

  ScreeningsEntity({
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
}









