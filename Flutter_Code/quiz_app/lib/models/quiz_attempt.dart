class QuizAttempt {
  final int score;
  final int totalQuestions;
  final DateTime date;

  QuizAttempt({
    required this.score,
    required this.totalQuestions,
    required this.date,
  });

  double get percentage => (score / totalQuestions) * 100;

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
    };
  }

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
