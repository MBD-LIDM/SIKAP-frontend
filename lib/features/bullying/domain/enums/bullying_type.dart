enum BullyingType {
  verbal,
  physical,
  cyber,
  social,
  sexual,
  other,
}

extension BullyingTypeExtension on BullyingType {
  String get value {
    switch (this) {
      case BullyingType.verbal:
        return 'verbal';
      case BullyingType.physical:
        return 'physical';
      case BullyingType.cyber:
        return 'cyber';
      case BullyingType.social:
        return 'social';
      case BullyingType.sexual:
        return 'sexual';
      case BullyingType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case BullyingType.verbal:
        return 'Verbal';
      case BullyingType.physical:
        return 'Fisik';
      case BullyingType.cyber:
        return 'Cyber';
      case BullyingType.social:
        return 'Sosial';
      case BullyingType.sexual:
        return 'Seksual';
      case BullyingType.other:
        return 'Lainnya';
    }
  }

  static BullyingType fromString(String value) {
    switch (value) {
      case 'verbal':
        return BullyingType.verbal;
      case 'physical':
        return BullyingType.physical;
      case 'cyber':
        return BullyingType.cyber;
      case 'social':
        return BullyingType.social;
      case 'sexual':
        return BullyingType.sexual;
      case 'other':
        return BullyingType.other;
      default:
        return BullyingType.other;
    }
  }
}










