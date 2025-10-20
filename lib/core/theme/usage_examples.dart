// Contoh penggunaan Google Fonts di berbagai komponen
// File ini hanya untuk referensi, tidak digunakan dalam aplikasi

import 'package:flutter/material.dart';
import 'app_theme.dart';

class UsageExamples {
  // Contoh 1: Homepage Title
  static Widget homepageTitle() {
    return Text(
      'Tempat untuk Didengar',
      style: AppTheme.headingLarge, // Abril Fatface, 32px, bold, white
    );
  }

  // Contoh 2: Feature Button
  static Widget featureButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.creamBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lapor Bullying',
            style: AppTheme.buttonText, // Roboto, 18px, bold, orange
          ),
          const SizedBox(height: 4),
          Text(
            'Identitas kamu terjaga',
            style: AppTheme.subtitle, // Roboto, 14px, dark grey
          ),
        ],
      ),
    );
  }

  // Contoh 3: Form Input
  static Widget formInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: AppTheme.bodyMedium, // Roboto, 14px, light grey
      ),
      style: AppTheme.bodyLarge, // Roboto, 16px, white
    );
  }

  // Contoh 4: Settings Button
  static Widget settingsButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.creamBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(width: 16),
          Text(
            'Pengaturan',
            style: AppTheme.buttonTextPurple, // Roboto, 18px, bold, purple
          ),
        ],
      ),
    );
  }

  // Contoh 5: Card dengan berbagai text styles
  static Widget infoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Penting',
              style: AppTheme.headingMedium, // Abril Fatface, 24px, bold, white
            ),
            const SizedBox(height: 8),
            Text(
              'Ini adalah informasi penting yang perlu diketahui pengguna.',
              style: AppTheme.bodyLarge, // Roboto, 16px, white
            ),
            const SizedBox(height: 4),
            Text(
              'Detail tambahan bisa ditulis di sini.',
              style: AppTheme.bodyMedium, // Roboto, 14px, light grey
            ),
          ],
        ),
      ),
    );
  }
}










