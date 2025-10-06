enum ResourceCategory {
  mentalHealth,
  stressManagement,
  mindfulness,
  selfCare,
  relationships,
  productivity,
  sleep,
  nutrition,
  exercise,
  therapy,
  other,
}

extension ResourceCategoryExtension on ResourceCategory {
  String get value {
    switch (this) {
      case ResourceCategory.mentalHealth:
        return 'mental_health';
      case ResourceCategory.stressManagement:
        return 'stress_management';
      case ResourceCategory.mindfulness:
        return 'mindfulness';
      case ResourceCategory.selfCare:
        return 'self_care';
      case ResourceCategory.relationships:
        return 'relationships';
      case ResourceCategory.productivity:
        return 'productivity';
      case ResourceCategory.sleep:
        return 'sleep';
      case ResourceCategory.nutrition:
        return 'nutrition';
      case ResourceCategory.exercise:
        return 'exercise';
      case ResourceCategory.therapy:
        return 'therapy';
      case ResourceCategory.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ResourceCategory.mentalHealth:
        return 'Kesehatan Mental';
      case ResourceCategory.stressManagement:
        return 'Manajemen Stres';
      case ResourceCategory.mindfulness:
        return 'Mindfulness';
      case ResourceCategory.selfCare:
        return 'Perawatan Diri';
      case ResourceCategory.relationships:
        return 'Hubungan';
      case ResourceCategory.productivity:
        return 'Produktivitas';
      case ResourceCategory.sleep:
        return 'Tidur';
      case ResourceCategory.nutrition:
        return 'Nutrisi';
      case ResourceCategory.exercise:
        return 'Olahraga';
      case ResourceCategory.therapy:
        return 'Terapi';
      case ResourceCategory.other:
        return 'Lainnya';
    }
  }

  static ResourceCategory fromString(String value) {
    switch (value) {
      case 'mental_health':
        return ResourceCategory.mentalHealth;
      case 'stress_management':
        return ResourceCategory.stressManagement;
      case 'mindfulness':
        return ResourceCategory.mindfulness;
      case 'self_care':
        return ResourceCategory.selfCare;
      case 'relationships':
        return ResourceCategory.relationships;
      case 'productivity':
        return ResourceCategory.productivity;
      case 'sleep':
        return ResourceCategory.sleep;
      case 'nutrition':
        return ResourceCategory.nutrition;
      case 'exercise':
        return ResourceCategory.exercise;
      case 'therapy':
        return ResourceCategory.therapy;
      case 'other':
        return ResourceCategory.other;
      default:
        return ResourceCategory.other;
    }
  }
}









