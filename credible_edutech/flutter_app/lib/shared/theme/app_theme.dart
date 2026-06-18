import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _darkBg = Color(0xFF0F1419);
  static const Color _darkSurface = Color(0xFF1a1f2a);
  static const Color _accentBlue = Color(0xFF0066FF);
  static const Color _accentGreen = Color(0xFF00D084);
  static const Color _textPrimary = Color(0xFFE8E8E8);
  static const Color _textSecondary = Color(0xFF9E9E9E);
  static const Color _borderColor = Color(0xFF2a3042);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _accentBlue),
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: _textPrimary,
        displayColor: _textPrimary,
      ),
      colorScheme: ColorScheme.dark(
        primary: _accentBlue,
        secondary: _accentGreen,
        surface: _darkSurface,
        error: const Color(0xFFFF5252),
        background: _darkBg,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _accentBlue, width: 2),
        ),
        hintStyle: const TextStyle(color: _textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      cardTheme: CardTheme(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _borderColor, width: 1),
        ),
      ),
    );
  }

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static const double borderRadius = 12;
}
