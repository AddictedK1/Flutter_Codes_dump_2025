class TodoModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Priority priority;

  const TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
    required this.priority,
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    Priority? priority,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      priority: Priority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => Priority.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'priority': priority.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TodoModel{id: $id, title: $title, isCompleted: $isCompleted, priority: $priority}';
  }
}

enum Priority { low, medium, high }

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }
}
