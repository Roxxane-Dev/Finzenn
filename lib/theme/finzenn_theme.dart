import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinzennTheme {
  // ── Paleta "Amplify Wealth" definitiva ──────────────────────────
  static const Color bgColor       = Color(0xFFF3F4F9);
  static const Color primaryBlue   = Color(0xFF2D5BFF);
  static const Color royalBlueDark = Color(0xFF122E99);
  static const Color softPurple    = Color(0xFFC8C8FF);
  static const Color white         = Color(0xFFFFFFFF);
  static const Color success       = Color(0xFF00D084);
  static const Color error         = Color(0xFFFF4D4D);
  static const Color textDark      = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted     = Color(0xFF9CA3AF);

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2B59FF), Color(0xFF122E99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    final base = GoogleFonts.manropeTextTheme();
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgColor,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: softPurple,
        surface: white,
        onSurface: textDark,
        error: error,
      ),
      textTheme: base.copyWith(
        headlineMedium: base.headlineMedium?.copyWith(
          color: textDark, fontWeight: FontWeight.w800, fontSize: 24),
        bodyLarge:  base.bodyLarge?.copyWith(color: textDark, fontSize: 16),
        bodyMedium: base.bodyMedium?.copyWith(color: textSecondary, fontSize: 14),
      ),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}