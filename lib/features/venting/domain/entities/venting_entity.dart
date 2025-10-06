class VentingEntity {
  final String id;
  final String title;
  final String content;
  final String mood;
  final String privacy;
  final String userId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int commentsCount;

  VentingEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.privacy,
    required this.userId,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
  });
}









