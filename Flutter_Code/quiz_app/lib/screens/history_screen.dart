import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_attempt.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<QuizAttempt> attempts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('quiz_history') ?? [];

    setState(() {
      attempts = history
          .map((jsonStr) => QuizAttempt.fromJson(jsonDecode(jsonStr)))
          .toList()
          .reversed
          .toList(); // Show most recent first
      isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all quiz history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_history');
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (attempts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: 'Clear History',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attempts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No quiz history yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Take a quiz to see your results here',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                final attempt = attempts[index];
                final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: attempt.percentage >= 70
                          ? Colors.green
                          : attempt.percentage >= 50
                          ? Colors.orange
                          : Colors.red,
                      child: Text(
                        '${attempt.percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Score: ${attempt.score}/${attempt.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        dateFormat.format(attempt.date),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    trailing: Icon(
                      attempt.percentage >= 70
                          ? Icons.emoji_events
                          : Icons.star,
                      color: attempt.percentage >= 70
                          ? Colors.amber
                          : Colors.grey,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
