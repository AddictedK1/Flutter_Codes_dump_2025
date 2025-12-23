import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StepApp());
}

class StepApp extends StatelessWidget {
  const StepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
