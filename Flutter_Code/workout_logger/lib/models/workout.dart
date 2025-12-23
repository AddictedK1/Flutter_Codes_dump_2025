class Workout {
  final String id;
  final String exercise;
  final int durationMinutes;
  final int calories;
  final DateTime date;

  Workout({
    required this.id,
    required this.exercise,
    required this.durationMinutes,
    required this.calories,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise,
      'durationMinutes': durationMinutes,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      exercise: json['exercise'] as String,
      durationMinutes: json['durationMinutes'] as int,
      calories: json['calories'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Workout copyWith({
    String? id,
    String? exercise,
    int? durationMinutes,
    int? calories,
    DateTime? date,
  }) {
    return Workout(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      date: date ?? this.date,
    );
  }
}

class ExerciseType {
  static const List<String> exercises = [
    'Running',
    'Cycling',
    'Swimming',
    'Weightlifting',
    'Yoga',
    'Pilates',
    'Walking',
    'HIIT',
    'Boxing',
    'Dancing',
    'Rowing',
    'Stretching',
  ];
}
