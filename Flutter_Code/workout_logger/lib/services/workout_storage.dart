import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';

class WorkoutStorage {
  static const String _workoutsKey = 'workouts';

  Future<List<Workout>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? workoutsJson = prefs.getString(_workoutsKey);

    if (workoutsJson == null || workoutsJson.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(workoutsJson);
    return decoded.map((json) => Workout.fromJson(json)).toList();
  }

  Future<void> saveWorkout(Workout workout) async {
    final workouts = await getWorkouts();
    workouts.add(workout);
    await _saveWorkouts(workouts);
  }

  Future<void> updateWorkout(Workout workout) async {
    final workouts = await getWorkouts();
    final index = workouts.indexWhere((w) => w.id == workout.id);

    if (index != -1) {
      workouts[index] = workout;
      await _saveWorkouts(workouts);
    }
  }

  Future<void> deleteWorkout(String id) async {
    final workouts = await getWorkouts();
    workouts.removeWhere((w) => w.id == id);
    await _saveWorkouts(workouts);
  }

  Future<void> _saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(workouts.map((w) => w.toJson()).toList());
    await prefs.setString(_workoutsKey, encoded);
  }

  Future<List<Workout>> getWorkoutsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final workouts = await getWorkouts();
    return workouts.where((w) {
      return w.date.isAfter(start.subtract(const Duration(days: 1))) &&
          w.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<Workout>> getWorkoutsByExerciseType(String exercise) async {
    final workouts = await getWorkouts();
    return workouts.where((w) => w.exercise == exercise).toList();
  }

  Future<List<Workout>> filterWorkouts({
    String? exercise,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final workouts = await getWorkouts();

    return workouts.where((w) {
      bool matchesExercise = exercise == null || w.exercise == exercise;
      bool matchesStartDate =
          startDate == null ||
          w.date.isAfter(startDate.subtract(const Duration(days: 1)));
      bool matchesEndDate =
          endDate == null ||
          w.date.isBefore(endDate.add(const Duration(days: 1)));

      return matchesExercise && matchesStartDate && matchesEndDate;
    }).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workoutsKey);
  }
}
