import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  static const String _todosKey = 'todos_list';

  final RxList<TodoModel> _todos = <TodoModel>[].obs;
  final RxString _searchQuery = ''.obs;
  final Rx<Priority?> _selectedPriority = Rx<Priority?>(null);
  final RxBool _showCompleted = true.obs;

  List<TodoModel> get todos => _todos;
  String get searchQuery => _searchQuery.value;
  Priority? get selectedPriority => _selectedPriority.value;
  bool get showCompleted => _showCompleted.value;

  List<TodoModel> get filteredTodos {
    List<TodoModel> filtered = _todos;

    // Filter by completion status
    if (!_showCompleted.value) {
      filtered = filtered.where((todo) => !todo.isCompleted).toList();
    }

    // Filter by priority
    if (_selectedPriority.value != null) {
      filtered = filtered
          .where((todo) => todo.priority == _selectedPriority.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((todo) {
        final query = _searchQuery.value.toLowerCase();
        return todo.title.toLowerCase().contains(query) ||
            (todo.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by priority (high -> medium -> low) and then by creation date
    filtered.sort((a, b) {
      final priorityComparison = _comparePriority(a.priority, b.priority);
      if (priorityComparison != 0) return priorityComparison;
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  int _comparePriority(Priority a, Priority b) {
    const priorityOrder = {
      Priority.high: 3,
      Priority.medium: 2,
      Priority.low: 1,
    };
    return (priorityOrder[b] ?? 0) - (priorityOrder[a] ?? 0);
  }

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getStringList(_todosKey) ?? [];
      _todos.value = todosJson
          .map((todoJson) => TodoModel.fromJson(json.decode(todoJson)))
          .toList();
      update(); // Trigger GetBuilder update
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }

  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = _todos
          .map((todo) => json.encode(todo.toJson()))
          .toList();
      await prefs.setStringList(_todosKey, todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  Future<void> addTodo({
    required String title,
    String? description,
    Priority priority = Priority.medium,
  }) async {
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: priority,
    );

    _todos.add(todo);
    await _saveTodos();
    update(); // Trigger GetBuilder update
  }

  Future<void> updateTodo(TodoModel updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo.copyWith(updatedAt: DateTime.now());
      await _saveTodos();
      update(); // Trigger GetBuilder update
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _saveTodos();
    update(); // Trigger GetBuilder update
  }

  Future<void> toggleTodoCompletion(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        updatedAt: DateTime.now(),
      );
      await _saveTodos();
      update(); // Trigger GetBuilder update
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    update(); // Trigger GetBuilder update
  }

  void setSelectedPriority(Priority? priority) {
    _selectedPriority.value = priority;
    update(); // Trigger GetBuilder update
  }

  void toggleShowCompleted() {
    _showCompleted.value = !_showCompleted.value;
    update(); // Trigger GetBuilder update
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedPriority.value = null;
    _showCompleted.value = true;
    update(); // Trigger GetBuilder update
  }

  // Statistics
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((todo) => todo.isCompleted).length;
  int get pendingTodos => _todos.where((todo) => !todo.isCompleted).length;
  int get highPriorityTodos => _todos
      .where((todo) => todo.priority == Priority.high && !todo.isCompleted)
      .length;
}
