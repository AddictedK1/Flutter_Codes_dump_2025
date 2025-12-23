import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;
  static const String _themeKey = 'selected_theme';

  AppTheme get currentTheme => _currentTheme;
  ThemeData get themeData => AppThemes.getThemeFromEnum(_currentTheme);

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _currentTheme = AppTheme.values[themeIndex];
    notifyListeners();
  }

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }
}
