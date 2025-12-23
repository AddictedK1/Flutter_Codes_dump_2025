import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _tasksKey = 'tasks';

  // Save tasks to shared preferences
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(tasksJson));
  }

  // Load tasks from shared preferences
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);

    if (tasksString == null || tasksString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      return tasksJson
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  // Clear all tasks
  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
