# Homepage Widgets

## FeatureButtonPlaceholder

Widget ini adalah placeholder untuk tombol-tombol fitur utama di homepage. Saat ini menggunakan icon Flutter standar, tetapi dirancang untuk mudah diganti dengan SVG.

### Cara Mengganti dengan SVG:

1. **Tambahkan dependency SVG** di `pubspec.yaml`:
```yaml
dependencies:
  flutter_svg: ^2.0.9
```

2. **Import flutter_svg** di file widget:
```dart
import 'package:flutter_svg/flutter_svg.dart';
```

3. **Ganti Container placeholder** dengan SvgPicture:
```dart
// Ganti bagian ini:
Container(
  width: 60,
  height: 60,
  decoration: BoxDecoration(...),
  child: Icon(...),
),

// Dengan ini:
SvgPicture.asset(
  'assets/images/bullying_icon.svg', // Path ke file SVG
  width: 60,
  height: 60,
),
```

### Struktur SVG yang Direkomendasikan:

- **Lapor Bullying**: `assets/images/bullying_icon.svg`
- **Pojok Tenang**: `assets/images/quiet_corner_icon.svg`
- **Jejak Intervensi**: `assets/images/intervention_icon.svg`
- **Pengaturan**: `assets/images/settings_icon.svg`

### Catatan:
- Pastikan file SVG sudah dioptimalkan untuk mobile
- Ukuran yang direkomendasikan: 60x60 pixels
- Warna SVG akan mengikuti tema aplikasi










