enum VentingMood {
  happy,
  sad,
  angry,
  anxious,
  stressed,
  confused,
  excited,
  frustrated,
  grateful,
  lonely,
  other,
}

extension VentingMoodExtension on VentingMood {
  String get value {
    switch (this) {
      case VentingMood.happy:
        return 'happy';
      case VentingMood.sad:
        return 'sad';
      case VentingMood.angry:
        return 'angry';
      case VentingMood.anxious:
        return 'anxious';
      case VentingMood.stressed:
        return 'stressed';
      case VentingMood.confused:
        return 'confused';
      case VentingMood.excited:
        return 'excited';
      case VentingMood.frustrated:
        return 'frustrated';
      case VentingMood.grateful:
        return 'grateful';
      case VentingMood.lonely:
        return 'lonely';
      case VentingMood.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case VentingMood.happy:
        return 'Senang';
      case VentingMood.sad:
        return 'Sedih';
      case VentingMood.angry:
        return 'Marah';
      case VentingMood.anxious:
        return 'Cemas';
      case VentingMood.stressed:
        return 'Stres';
      case VentingMood.confused:
        return 'Bingung';
      case VentingMood.excited:
        return 'Bersemangat';
      case VentingMood.frustrated:
        return 'Frustrasi';
      case VentingMood.grateful:
        return 'Bersyukur';
      case VentingMood.lonely:
        return 'Kesepian';
      case VentingMood.other:
        return 'Lainnya';
    }
  }

  static VentingMood fromString(String value) {
    switch (value) {
      case 'happy':
        return VentingMood.happy;
      case 'sad':
        return VentingMood.sad;
      case 'angry':
        return VentingMood.angry;
      case 'anxious':
        return VentingMood.anxious;
      case 'stressed':
        return VentingMood.stressed;
      case 'confused':
        return VentingMood.confused;
      case 'excited':
        return VentingMood.excited;
      case 'frustrated':
        return VentingMood.frustrated;
      case 'grateful':
        return VentingMood.grateful;
      case 'lonely':
        return VentingMood.lonely;
      case 'other':
        return VentingMood.other;
      default:
        return VentingMood.other;
    }
  }
}










