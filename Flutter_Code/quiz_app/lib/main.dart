import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/review_screen.dart';
import 'models/question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ResultsScreen(
              score: args['score'] as int,
              total: args['total'] as int,
              questions: args['questions'] as List<Question>,
              selectedAnswers: args['selectedAnswers'] as List<int?>,
            ),
          );
        } else if (settings.name == '/review') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ReviewScreen(
              questions: args['questions'] as List<Question>,
              selectedAnswers: args['selectedAnswers'] as List<int?>,
            ),
          );
        }
        return null;
      },
    );
  }
}
