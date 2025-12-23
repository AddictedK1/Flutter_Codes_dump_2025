import 'package:flutter/material.dart';
import 'package:invoice_app/screens/home_screen.dart';
import 'package:invoice_app/screens/profile_screen.dart';
import 'package:invoice_app/screens/search_screen.dart';
import 'package:invoice_app/screens/settings_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  List screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice App")),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (v) {
          currentIndex = v;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
