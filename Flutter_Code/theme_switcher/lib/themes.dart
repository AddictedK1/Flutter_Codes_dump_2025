import 'package:flutter/material.dart';

enum AppTheme { light, dark, customBlue }

class AppThemes {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      primary: Colors.grey[800]!,
      secondary: Colors.grey[700]!,
      surface: Colors.grey[850]!,
      background: Colors.grey[900]!,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[850],
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
    ),
  );

  // Custom Blue Theme
  static ThemeData customBlueTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E3A8A), // Deep Blue
    scaffoldBackgroundColor: const Color(0xFFE0F2FE), // Light Sky Blue
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E3A8A), // Deep Blue
      secondary: Color(0xFF3B82F6), // Bright Blue
      surface: Color(0xFFBAE6FD), // Sky Blue
      background: Color(0xFFE0F2FE), // Light Sky Blue
      error: Color(0xFFDC2626),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1E3A8A),
      onBackground: Color(0xFF1E3A8A),
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E3A8A), // Deep Blue
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFBAE6FD), // Sky Blue
      elevation: 4,
      shadowColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF3B82F6), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6), // Bright Blue
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A8A),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A8A),
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A8A),
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E3A8A),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1E3A8A)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF1E3A8A)),
    ),
  );

  static ThemeData getThemeFromEnum(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return lightTheme;
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.customBlue:
        return customBlueTheme;
    }
  }

  static String getThemeName(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.customBlue:
        return 'Custom Blue';
    }
  }
}
