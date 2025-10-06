enum AccountsStatus {
  active,
  inactive,
  suspended,
  pending,
}

extension AccountsStatusExtension on AccountsStatus {
  String get value {
    switch (this) {
      case AccountsStatus.active:
        return 'active';
      case AccountsStatus.inactive:
        return 'inactive';
      case AccountsStatus.suspended:
        return 'suspended';
      case AccountsStatus.pending:
        return 'pending';
    }
  }

  static AccountsStatus fromString(String value) {
    switch (value) {
      case 'active':
        return AccountsStatus.active;
      case 'inactive':
        return AccountsStatus.inactive;
      case 'suspended':
        return AccountsStatus.suspended;
      case 'pending':
        return AccountsStatus.pending;
      default:
        return AccountsStatus.pending;
    }
  }
}









