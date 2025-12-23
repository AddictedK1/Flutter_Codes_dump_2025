import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.light;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('selected_theme') ?? 0;
    setState(() {
      _currentTheme = AppTheme.values[themeIndex];
      _isLoading = false;
    });
  }

  Future<void> _changeTheme(AppTheme theme) async {
    setState(() {
      _currentTheme = theme;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_theme', theme.index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Multi-Theme Switcher',
      theme: AppThemes.getThemeFromEnum(_currentTheme),
      debugShowCheckedModeBanner: false,
      home: HomePage(currentTheme: _currentTheme, onThemeChanged: _changeTheme),
    );
  }
}
