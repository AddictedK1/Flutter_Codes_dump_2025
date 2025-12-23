import 'package:flutter/material.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  List color = [
    Colors.blue,
    Colors.purple,
    Colors.yellow,
    Colors.green,
    Colors.red,
  ];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded( 
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Field 1",
                  hintText: "manav",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            
            const SizedBox(width: 10),
            
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Field 2",
                  border: OutlineInputBorder(),
                ),
              ),
            
            const SizedBox(width: 10),
            
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Field 3",
                  border: OutlineInputBorder(),
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}
