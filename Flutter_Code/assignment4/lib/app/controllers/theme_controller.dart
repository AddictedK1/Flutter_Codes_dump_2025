import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'is_dark_mode';

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  RxBool get isDarkModeRx => _isDarkMode;

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode.value = prefs.getBool(_themeKey) ?? false;
      update(); // Trigger GetBuilder update
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode.value);
      update(); // Trigger GetBuilder update
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      _isDarkMode.value = isDark;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
      update(); // Trigger GetBuilder update
    } catch (e) {
      debugPrint('Error setting theme: $e');
    }
  }
}
