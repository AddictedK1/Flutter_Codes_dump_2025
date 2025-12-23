class Task {
  final String id;
  String title;
  bool isCompleted;
  bool isImportant;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isImportant = false,
  });

  // Convert Task to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'isImportant': isImportant,
    };
  }

  // Create Task from Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isImportant: json['isImportant'] as bool? ?? false,
    );
  }

  // Create a copy of Task with updated fields
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isImportant,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
