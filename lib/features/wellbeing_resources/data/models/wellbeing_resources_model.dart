class WellbeingResourcesModel {
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

  WellbeingResourcesModel({
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

  factory WellbeingResourcesModel.fromJson(Map<String, dynamic> json) {
    return WellbeingResourcesModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
      documentUrl: json['document_url'],
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? '',
      authorId: json['author_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      viewsCount: json['views_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'category': category,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'document_url': documentUrl,
      'tags': tags,
      'status': status,
      'author_id': authorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'views_count': viewsCount,
      'likes_count': likesCount,
    };
  }
}









