enum VentingPrivacy {
  private,
  friends,
  public,
}

extension VentingPrivacyExtension on VentingPrivacy {
  String get value {
    switch (this) {
      case VentingPrivacy.private:
        return 'private';
      case VentingPrivacy.friends:
        return 'friends';
      case VentingPrivacy.public:
        return 'public';
    }
  }

  String get displayName {
    switch (this) {
      case VentingPrivacy.private:
        return 'Pribadi';
      case VentingPrivacy.friends:
        return 'Teman';
      case VentingPrivacy.public:
        return 'Publik';
    }
  }

  static VentingPrivacy fromString(String value) {
    switch (value) {
      case 'private':
        return VentingPrivacy.private;
      case 'friends':
        return VentingPrivacy.friends;
      case 'public':
        return VentingPrivacy.public;
      default:
        return VentingPrivacy.private;
    }
  }
}









