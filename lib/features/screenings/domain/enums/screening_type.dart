enum ScreeningType {
  depression,
  anxiety,
  stress,
  wellbeing,
  mentalHealth,
  other,
}

extension ScreeningTypeExtension on ScreeningType {
  String get value {
    switch (this) {
      case ScreeningType.depression:
        return 'depression';
      case ScreeningType.anxiety:
        return 'anxiety';
      case ScreeningType.stress:
        return 'stress';
      case ScreeningType.wellbeing:
        return 'wellbeing';
      case ScreeningType.mentalHealth:
        return 'mental_health';
      case ScreeningType.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ScreeningType.depression:
        return 'Depresi';
      case ScreeningType.anxiety:
        return 'Kecemasan';
      case ScreeningType.stress:
        return 'Stres';
      case ScreeningType.wellbeing:
        return 'Kesejahteraan';
      case ScreeningType.mentalHealth:
        return 'Kesehatan Mental';
      case ScreeningType.other:
        return 'Lainnya';
    }
  }

  static ScreeningType fromString(String value) {
    switch (value) {
      case 'depression':
        return ScreeningType.depression;
      case 'anxiety':
        return ScreeningType.anxiety;
      case 'stress':
        return ScreeningType.stress;
      case 'wellbeing':
        return ScreeningType.wellbeing;
      case 'mental_health':
        return ScreeningType.mentalHealth;
      case 'other':
        return ScreeningType.other;
      default:
        return ScreeningType.other;
    }
  }
}









