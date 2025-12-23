import 'package:flutter/material.dart';
import '../services/shared_prefs.dart';
import 'intro_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(Duration(seconds: 2)); // splash delay
    bool firstLaunch = await SharedPrefs.isFirstLaunch();

    if (firstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen", style: TextStyle(fontSize: 24))),
    );
  }
}
