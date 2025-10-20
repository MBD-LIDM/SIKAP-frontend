enum BullyingSeverity {
  low,
  medium,
  high,
  critical,
}

extension BullyingSeverityExtension on BullyingSeverity {
  String get value {
    switch (this) {
      case BullyingSeverity.low:
        return 'low';
      case BullyingSeverity.medium:
        return 'medium';
      case BullyingSeverity.high:
        return 'high';
      case BullyingSeverity.critical:
        return 'critical';
    }
  }

  String get displayName {
    switch (this) {
      case BullyingSeverity.low:
        return 'Rendah';
      case BullyingSeverity.medium:
        return 'Sedang';
      case BullyingSeverity.high:
        return 'Tinggi';
      case BullyingSeverity.critical:
        return 'Kritis';
    }
  }

  static BullyingSeverity fromString(String value) {
    switch (value) {
      case 'low':
        return BullyingSeverity.low;
      case 'medium':
        return BullyingSeverity.medium;
      case 'high':
        return BullyingSeverity.high;
      case 'critical':
        return BullyingSeverity.critical;
      default:
        return BullyingSeverity.medium;
    }
  }
}










