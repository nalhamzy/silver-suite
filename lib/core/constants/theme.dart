import 'package:flutter/material.dart';

/// Silver Suite — high contrast, large type, senior-first.
/// WCAG AAA-leaning palette. Minimum 18pt body, 24pt buttons.
class AppTheme {
  // Palette
  static const bg = Color(0xFFF7F5F1);         // warm off-white
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF101623);        // near-black for max contrast
  static const mute = Color(0xFF4A556B);       // dark gray — still AA body
  static const outline = Color(0xFFD6D8DE);

  // Bold accents — saturated enough to read in sunlight
  static const blue = Color(0xFF1864C0);       // primary action
  static const teal = Color(0xFF077D83);       // safe / connect
  static const red = Color(0xFFC02B2B);        // emergency
  static const amber = Color(0xFFE08900);      // alerts / reminders
  static const green = Color(0xFF2F8A3E);      // done / wellness
  static const indigo = Color(0xFF3A3BB7);     // notes

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2F81DA), blue],
  );
  static const redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE14B4B), red],
  );
  static const amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5A827), amber],
  );
  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4BB35E), green],
  );
  static const tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2BA3A8), teal],
  );
  static const indigoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6F70D8), indigo],
  );

  static ThemeData light(double scale) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.light(
          primary: blue,
          secondary: teal,
          surface: surface,
          onSurface: ink,
          error: red,
          outline: outline,
        ),
        textTheme: _textTheme(scale, ink),
        cardTheme: const CardThemeData(
          color: card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            side: BorderSide(color: outline),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
      );

  static ThemeData dark(double scale) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C0F15),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5CA1E8),
          secondary: Color(0xFF4DBCC2),
          surface: Color(0xFF161A22),
          onSurface: Color(0xFFF3F4F7),
          error: Color(0xFFE95A5A),
          outline: Color(0xFF2A2F3B),
        ),
        textTheme: _textTheme(scale, const Color(0xFFF3F4F7)),
        cardTheme: const CardThemeData(
          color: Color(0xFF161A22),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            side: BorderSide(color: Color(0xFF2A2F3B)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0C0F15),
          foregroundColor: Color(0xFFF3F4F7),
          elevation: 0,
          centerTitle: false,
        ),
      );

  static TextTheme _textTheme(double scale, Color color) => TextTheme(
        displayLarge: TextStyle(
          fontSize: 44 * scale,
          fontWeight: FontWeight.w900,
          color: color,
          height: 1.05,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 36 * scale,
          fontWeight: FontWeight.w800,
          color: color,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          fontSize: 28 * scale,
          fontWeight: FontWeight.w800,
          color: color,
        ),
        headlineSmall: TextStyle(
          fontSize: 22 * scale,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        titleLarge: TextStyle(
          fontSize: 20 * scale,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        bodyLarge: TextStyle(
          fontSize: 19 * scale,
          fontWeight: FontWeight.w500,
          color: color,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 17 * scale,
          fontWeight: FontWeight.w500,
          color: color,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 18 * scale,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.4,
        ),
      );
}
