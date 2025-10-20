enum ScreeningStatus {
  draft,
  active,
  completed,
  expired,
  cancelled,
}

extension ScreeningStatusExtension on ScreeningStatus {
  String get value {
    switch (this) {
      case ScreeningStatus.draft:
        return 'draft';
      case ScreeningStatus.active:
        return 'active';
      case ScreeningStatus.completed:
        return 'completed';
      case ScreeningStatus.expired:
        return 'expired';
      case ScreeningStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case ScreeningStatus.draft:
        return 'Draft';
      case ScreeningStatus.active:
        return 'Aktif';
      case ScreeningStatus.completed:
        return 'Selesai';
      case ScreeningStatus.expired:
        return 'Kedaluwarsa';
      case ScreeningStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  static ScreeningStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return ScreeningStatus.draft;
      case 'active':
        return ScreeningStatus.active;
      case 'completed':
        return ScreeningStatus.completed;
      case 'expired':
        return ScreeningStatus.expired;
      case 'cancelled':
        return ScreeningStatus.cancelled;
      default:
        return ScreeningStatus.draft;
    }
  }
}










