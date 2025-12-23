import 'package:flutter/material.dart';

class StepDisplay extends StatelessWidget {
  final int stepCount;

  const StepDisplay({super.key, required this.stepCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.directions_walk, size: 100),
        const SizedBox(height: 20),
        Text(
          "$stepCount",
          style: const TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold),
        ),
        const Text("Steps", style: TextStyle(fontSize: 25)),
      ],
    );
  }
}
