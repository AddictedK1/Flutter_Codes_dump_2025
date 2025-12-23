import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  // Example questions
  final List<Map<String, Object>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'London', 'Paris', 'Madrid'],
      'answer': 2,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 1,
    },
    {
      'question': 'Who wrote Hamlet?',
      'options': [
        'Charles Dickens',
        'William Shakespeare',
        'Mark Twain',
        'Jane Austen',
      ],
      'answer': 1,
    },
  ];

  int _currentQuestion = 0;
  int? _selectedOption;
  int _score = 0;
  bool _showResult = false;

  void _nextQuestion() {
    if (_selectedOption == _questions[_currentQuestion]['answer']) {
      _score++;
    }
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _selectedOption = null;
      _score = 0;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _showResult
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your Score: \\$_score / \\${_questions.length}',
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _restartQuiz,
                      child: Text('Restart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question \\${_currentQuestion + 1} of \\${_questions.length}',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _questions[_currentQuestion]['question'] as String,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ...List.generate(4, (index) {
                      final option =
                          (_questions[_currentQuestion]['options']
                              as List<String>)[index];
                      final isSelected = _selectedOption == index;
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: _selectedOption == null
                              ? () {
                                  setState(() {
                                    _selectedOption = index;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.deepPurple
                                : Colors.white,
                            foregroundColor: isSelected
                                ? Colors.white
                                : Colors.deepPurple,
                            side: BorderSide(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text(option),
                        ),
                      );
                    }),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _selectedOption != null ? _nextQuestion : null,
                      child: Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Finish'
                            : 'Next',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
