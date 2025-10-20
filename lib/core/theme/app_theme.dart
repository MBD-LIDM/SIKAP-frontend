import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primaryPurple = Color(0xFF7F55B1);
  static const Color lightPeach = Color(0xFFFFDBB6);
  static const Color creamBackground = Color(0xFFF5F5DC);
  static const Color orangeAccent = Color(0xFFE65100);
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFF757575);

  // Text Styles
  static TextStyle get headingLarge => GoogleFonts.abrilFatface(
        fontSize: 32,
        color: Colors.white,
        height: 1.2,
      );

  static TextStyle get headingMedium => GoogleFonts.abrilFatface(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
        fontSize: 14,
        color: lightGrey,
        height: 1.4,
      );

  static TextStyle get buttonText => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: orangeAccent,
      );

  static TextStyle get buttonTextPurple => GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryPurple,
      );

  static TextStyle get subtitle => GoogleFonts.roboto(
        fontSize: 14,
        color: darkGrey,
        height: 1.4,
      );

  // App Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: buttonText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(
          color: lightGrey,
        ),
        hintStyle: GoogleFonts.roboto(
          color: lightGrey.withOpacity(0.7),
        ),
      ),
      cardTheme: CardTheme(
        color: creamBackground,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}










