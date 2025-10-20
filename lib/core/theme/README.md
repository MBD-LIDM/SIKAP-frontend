# App Theme & Google Fonts

## Overview
Aplikasi SIKAP menggunakan Google Fonts untuk konsistensi typography di seluruh fitur. Tema global telah dikonfigurasi di `AppTheme` class.

## Fonts yang Digunakan

### 1. Abril Fatface
- **Penggunaan**: Judul utama, heading besar
- **Contoh**: "Tempat untuk Didengar" di homepage
- **Style**: `AppTheme.headingLarge`, `AppTheme.headingMedium`

### 2. Roboto
- **Penggunaan**: Body text, button text, subtitle
- **Contoh**: Subtitle, button labels, form text
- **Style**: `AppTheme.bodyLarge`, `AppTheme.bodyMedium`, `AppTheme.buttonText`

## Cara Menggunakan

### 1. Import Theme
```dart
import '../../../core/theme/app_theme.dart';
```

### 2. Gunakan Predefined Styles
```dart
// Judul besar
Text('Judul', style: AppTheme.headingLarge)

// Body text
Text('Konten', style: AppTheme.bodyLarge)

// Button text
Text('Tombol', style: AppTheme.buttonText)
```

### 3. Gunakan Color Constants
```dart
Container(
  color: AppTheme.primaryPurple,
  child: Text('Text', style: AppTheme.bodyLarge),
)
```

## Available Styles

### Text Styles
- `AppTheme.headingLarge` - Judul utama (Abril Fatface, 32px)
- `AppTheme.headingMedium` - Judul sedang (Abril Fatface, 24px)
- `AppTheme.bodyLarge` - Body text besar (Roboto, 16px)
- `AppTheme.bodyMedium` - Body text sedang (Roboto, 14px)
- `AppTheme.buttonText` - Button text orange (Roboto, 18px)
- `AppTheme.buttonTextPurple` - Button text purple (Roboto, 18px)
- `AppTheme.subtitle` - Subtitle text (Roboto, 14px)

### Colors
- `AppTheme.primaryPurple` - #7F55B1
- `AppTheme.lightPeach` - #FFDBB6
- `AppTheme.creamBackground` - #F5F5DC
- `AppTheme.orangeAccent` - #E65100
- `AppTheme.darkGrey` - #424242
- `AppTheme.lightGrey` - #757575

## Best Practices

1. **Selalu gunakan predefined styles** untuk konsistensi
2. **Jangan hardcode font family** - gunakan AppTheme
3. **Gunakan color constants** untuk konsistensi warna
4. **Test di berbagai ukuran layar** untuk memastikan readability

## Menambah Font Baru

Jika perlu menambah font baru:

1. Tambahkan style baru di `AppTheme` class
2. Update dokumentasi ini
3. Test di berbagai komponen










