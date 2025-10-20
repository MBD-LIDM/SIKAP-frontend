class WellbeingResourcesEntity {
  final String id;
  final String title;
  final String description;
  final String type;
  final String category;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? documentUrl;
  final List<String> tags;
  final String status;
  final String authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int viewsCount;
  final int likesCount;

  WellbeingResourcesEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.documentUrl,
    required this.tags,
    required this.status,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
    required this.viewsCount,
    required this.likesCount,
  });
}










