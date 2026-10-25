import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF942222);
  static const Color primaryVariant = Color(0xFF8A0606);
  static const Color accent = Color(0xFFB20808);
  static const Color background = Color(0xFFEDD9CC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF1E1F22);
  static const Color error = Color(0xFFB20808);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: background,
        secondary: accent,
        surface: surface,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      textTheme: ThemeData.light().textTheme
          .copyWith(
            displayLarge: GoogleFonts.playfairDisplay(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
            displayMedium: GoogleFonts.playfairDisplay(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: GoogleFonts.poppins(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.poppins(color: textPrimary),
            bodyMedium: GoogleFonts.poppins(color: textSecondary),
          )
          .apply(fontFamily: GoogleFonts.poppins().fontFamily),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static LinearGradient topGradient({double fadeEnd = 0.77}) => LinearGradient(
    begin: Alignment.topRight,
    end: const Alignment(-1.3, -0.4),
    colors: const [primary, background, background],
    stops: [-0.9, fadeEnd, 0.8],
  );
}
