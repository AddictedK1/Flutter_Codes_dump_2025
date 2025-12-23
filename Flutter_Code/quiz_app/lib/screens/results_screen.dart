import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/quiz_attempt.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<Question> questions;
  final List<int?> selectedAnswers;

  const ResultsScreen({
    super.key,
    required this.score,
    required this.total,
    required this.questions,
    required this.selectedAnswers,
  });

  Future<void> _saveQuizAttempt() async {
    final prefs = await SharedPreferences.getInstance();
    final attempt = QuizAttempt(
      score: score,
      totalQuestions: total,
      date: DateTime.now(),
    );

    List<String> history = prefs.getStringList('quiz_history') ?? [];
    history.add(jsonEncode(attempt.toJson()));
    await prefs.setStringList('quiz_history', history);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).toStringAsFixed(1);

    // Save the attempt when screen is built
    _saveQuizAttempt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                score >= total * 0.7 ? Icons.celebration : Icons.emoji_events,
                size: 100,
                color: score >= total * 0.7 ? Colors.green : Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                score >= total * 0.7 ? 'Great Job!' : 'Good Effort!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You scored',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '$score / $total',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/review',
                    arguments: {
                      'questions': questions,
                      'selectedAnswers': selectedAnswers,
                    },
                  );
                },
                icon: const Icon(Icons.rate_review),
                label: const Text('Review Answers'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
