import 'package:flutter/material.dart';
import '../models/question.dart';

class ReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final List<int?> selectedAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final selectedAnswer = selectedAnswers[index];
          final correctAnswer = question.correctAnswer;
          final isCorrect = selectedAnswer == correctAnswer;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question number and status
                  Row(
                    children: [
                      Text(
                        'Question ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Question text
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  ...List.generate(question.options.length, (optionIndex) {
                    final isSelected = selectedAnswer == optionIndex;
                    final isCorrectOption = correctAnswer == optionIndex;

                    Color? tileColor;
                    IconData? icon;
                    Color? iconColor;

                    if (isCorrectOption) {
                      tileColor = Colors.green[50];
                      icon = Icons.check;
                      iconColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      tileColor = Colors.red[50];
                      icon = Icons.close;
                      iconColor = Colors.red;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrectOption
                              ? Colors.green
                              : (isSelected && !isCorrect)
                              ? Colors.red
                              : Colors.grey[300]!,
                          width: isCorrectOption || (isSelected && !isCorrect)
                              ? 2
                              : 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(question.options[optionIndex]),
                        trailing: icon != null
                            ? Icon(icon, color: iconColor)
                            : null,
                        dense: true,
                      ),
                    );
                  }),

                  // Explanation
                  if (!isCorrect) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Correct answer: ${question.options[correctAnswer]}',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
