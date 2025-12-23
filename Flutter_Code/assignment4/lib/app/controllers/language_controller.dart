import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';

  final Rx<Locale> _currentLocale = const Locale('en', 'US').obs;

  Locale get currentLocale => _currentLocale.value;
  Rx<Locale> get currentLocaleRx => _currentLocale;

  final List<Locale> supportedLocales = const [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('ar', 'SA'),
  ];

  final Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية',
  };

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        final locale = supportedLocales.firstWhereOrNull(
          (locale) => locale.languageCode == languageCode,
        );
        if (locale != null) {
          _currentLocale.value = locale;
          Get.updateLocale(locale);
          update(); // Trigger GetBuilder update
        }
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    try {
      if (supportedLocales.contains(locale)) {
        _currentLocale.value = locale;
        Get.updateLocale(locale);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, locale.languageCode);
        update(); // Trigger GetBuilder update
      }
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
}
