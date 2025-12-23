import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String firstLaunchKey = "first_launch";

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(firstLaunchKey, false);
  }
}
