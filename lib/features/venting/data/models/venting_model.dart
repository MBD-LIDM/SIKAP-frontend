class VentingModel {
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

  VentingModel({
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

  factory VentingModel.fromJson(Map<String, dynamic> json) {
    return VentingModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mood: json['mood'] ?? '',
      privacy: json['privacy'] ?? 'private',
      userId: json['user_id'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'privacy': privacy,
      'user_id': userId,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }
}










