import 'package:flutter/material.dart';
import '../widgets/step_display.dart';
import '../services/step_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StepService stepService = StepService();

  int steps = 0;

  @override
  void initState() {
    super.initState();

    stepService.stepStream.listen((event) {
      setState(() {
        steps = event.steps;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Step Counter")),
      body: Center(
        child: StepDisplay(stepCount: steps),
      ),
    );
  }
}
