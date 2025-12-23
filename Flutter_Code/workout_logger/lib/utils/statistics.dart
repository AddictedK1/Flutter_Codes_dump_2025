import '../models/workout.dart';

class WorkoutStatistics {
  // Calculate consecutive workout days (streak)
  static int calculateStreak(List<Workout> workouts) {
    if (workouts.isEmpty) return 0;

    // Sort workouts by date (descending)
    final sortedWorkouts = List<Workout>.from(workouts)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Get unique workout dates
    final uniqueDates = <DateTime>{};
    for (var workout in sortedWorkouts) {
      final dateOnly = DateTime(
        workout.date.year,
        workout.date.month,
        workout.date.day,
      );
      uniqueDates.add(dateOnly);
    }

    final datesList = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

    if (datesList.isEmpty) return 0;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterday = todayDate.subtract(const Duration(days: 1));

    // Check if the streak includes today or yesterday
    if (!datesList.first.isAtSameMomentAs(todayDate) &&
        !datesList.first.isAtSameMomentAs(yesterday)) {
      return 0; // Streak is broken
    }

    int streak = 1;
    for (int i = 1; i < datesList.length; i++) {
      final diff = datesList[i - 1].difference(datesList[i]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // Calculate weekly statistics
  static Map<String, dynamic> calculateWeeklyStats(
    List<Workout> workouts,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekWorkouts = workouts.where((w) {
      return w.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          w.date.isBefore(weekEnd);
    }).toList();

    int totalWorkouts = weekWorkouts.length;
    int totalMinutes = weekWorkouts.fold(
      0,
      (sum, w) => sum + w.durationMinutes,
    );
    int totalCalories = weekWorkouts.fold(0, (sum, w) => sum + w.calories);

    return {
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
      'totalCalories': totalCalories,
      'weekStart': weekStart,
      'weekEnd': weekEnd,
    };
  }

  // Calculate monthly statistics
  static Map<String, dynamic> calculateMonthlyStats(
    List<Workout> workouts,
    DateTime month,
  ) {
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final monthWorkouts = workouts.where((w) {
      return w.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          w.date.isBefore(monthEnd.add(const Duration(days: 1)));
    }).toList();

    int totalWorkouts = monthWorkouts.length;
    int totalMinutes = monthWorkouts.fold(
      0,
      (sum, w) => sum + w.durationMinutes,
    );
    int totalCalories = monthWorkouts.fold(0, (sum, w) => sum + w.calories);

    // Count workouts by exercise type
    final Map<String, int> exerciseCounts = {};
    for (var workout in monthWorkouts) {
      exerciseCounts[workout.exercise] =
          (exerciseCounts[workout.exercise] ?? 0) + 1;
    }

    // Find most popular exercise
    String? mostPopularExercise;
    int maxCount = 0;
    exerciseCounts.forEach((exercise, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopularExercise = exercise;
      }
    });

    return {
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
      'totalCalories': totalCalories,
      'averageMinutes': totalWorkouts > 0
          ? (totalMinutes / totalWorkouts).round()
          : 0,
      'averageCalories': totalWorkouts > 0
          ? (totalCalories / totalWorkouts).round()
          : 0,
      'exerciseCounts': exerciseCounts,
      'mostPopularExercise': mostPopularExercise,
      'monthStart': monthStart,
      'monthEnd': monthEnd,
    };
  }

  // Get last 7 days workout minutes for bar chart
  static Map<DateTime, int> getLast7DaysMinutes(List<Workout> workouts) {
    final today = DateTime.now();
    final Map<DateTime, int> dailyMinutes = {};

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: i));
      dailyMinutes[date] = 0;
    }

    for (var workout in workouts) {
      final dateOnly = DateTime(
        workout.date.year,
        workout.date.month,
        workout.date.day,
      );
      if (dailyMinutes.containsKey(dateOnly)) {
        dailyMinutes[dateOnly] =
            dailyMinutes[dateOnly]! + workout.durationMinutes;
      }
    }

    return dailyMinutes;
  }

  // Group workouts by week
  static Map<String, List<Workout>> groupByWeek(List<Workout> workouts) {
    final Map<String, List<Workout>> grouped = {};

    for (var workout in workouts) {
      final weekStart = _getWeekStart(workout.date);
      final weekEnd = weekStart.add(const Duration(days: 6));
      final weekKey = '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}';

      if (!grouped.containsKey(weekKey)) {
        grouped[weekKey] = [];
      }
      grouped[weekKey]!.add(workout);
    }

    return grouped;
  }

  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: weekday - 1));
  }

  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
