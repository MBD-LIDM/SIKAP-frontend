enum ResourceType {
  article,
  video,
  audio,
  document,
  infographic,
  exercise,
  meditation,
  other,
}

extension ResourceTypeExtension on ResourceType {
  String get value {
    switch (this) {
      case ResourceType.article:
        return 'article';
      case ResourceType.video:
        return 'video';
      case ResourceType.audio:
        return 'audio';
      case ResourceType.document:
        return 'document';
      case ResourceType.infographic:
        return 'infographic';
      case ResourceType.exercise:
        return 'exercise';
      case ResourceType.meditation:
        return 'meditation';
      case ResourceType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ResourceType.article:
        return 'Artikel';
      case ResourceType.video:
        return 'Video';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.document:
        return 'Dokumen';
      case ResourceType.infographic:
        return 'Infografis';
      case ResourceType.exercise:
        return 'Latihan';
      case ResourceType.meditation:
        return 'Meditasi';
      case ResourceType.other:
        return 'Lainnya';
    }
  }

  static ResourceType fromString(String value) {
    switch (value) {
      case 'article':
        return ResourceType.article;
      case 'video':
        return ResourceType.video;
      case 'audio':
        return ResourceType.audio;
      case 'document':
        return ResourceType.document;
      case 'infographic':
        return ResourceType.infographic;
      case 'exercise':
        return ResourceType.exercise;
      case 'meditation':
        return ResourceType.meditation;
      case 'other':
        return ResourceType.other;
      default:
        return ResourceType.other;
    }
  }
}










