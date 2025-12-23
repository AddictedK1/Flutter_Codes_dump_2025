import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("E-Book Dashboard")),
      body: Center(child: Text("E-Book Dashboard UI here")),
    );
  }
}
