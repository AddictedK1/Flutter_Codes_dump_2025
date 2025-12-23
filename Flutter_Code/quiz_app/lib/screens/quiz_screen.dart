import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  const QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<int?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(widget.questions.length, null);
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Quiz completed, navigate to results
      _showResults();
    }
  }

  void _showResults() {
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (selectedAnswers[i] == widget.questions[i].correctAnswer) {
        score++;
      }
    }

    Navigator.pushReplacementNamed(
      context,
      '/results',
      arguments: {
        'score': score,
        'total': widget.questions.length,
        'questions': widget.questions,
        'selectedAnswers': selectedAnswers,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Question
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text(question.options[index]),
                    value: index,
                    groupValue: selectedAnswers[currentQuestionIndex],
                    onChanged: (int? value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),

            // Next button
            ElevatedButton(
              onPressed: selectedAnswers[currentQuestionIndex] != null
                  ? _nextQuestion
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text(
                currentQuestionIndex < widget.questions.length - 1
                    ? 'Next'
                    : 'Finish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
