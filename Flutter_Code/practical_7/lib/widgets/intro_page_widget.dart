import 'package:flutter/material.dart';

class IntroPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const IntroPageWidget({super.key, 
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
