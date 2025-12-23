import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../services/workout_storage.dart';
import '../utils/statistics.dart';
import 'workout_entry_screen.dart';
import 'workout_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storage = WorkoutStorage();
  List<Workout> _workouts = [];
  Map<String, dynamic> _monthlyStats = {};
  int _currentStreak = 0;
  Map<DateTime, int> _last7DaysMinutes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final workouts = await _storage.getWorkouts();
    final monthlyStats = WorkoutStatistics.calculateMonthlyStats(
      workouts,
      DateTime.now(),
    );
    final streak = WorkoutStatistics.calculateStreak(workouts);
    final last7Days = WorkoutStatistics.getLast7DaysMinutes(workouts);

    setState(() {
      _workouts = workouts;
      _monthlyStats = monthlyStats;
      _currentStreak = streak;
      _last7DaysMinutes = last7Days;
      _isLoading = false;
    });
  }

  Future<void> _navigateToAddWorkout() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WorkoutEntryScreen()),
    );
    if (result == true) {
      _loadData();
    }
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WorkoutHistoryScreen()),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Logger'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToHistory,
            tooltip: 'View History',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Streak Card
              _buildStreakCard(),
              const SizedBox(height: 16),

              // Monthly Statistics
              _buildMonthlyStatsCard(),
              const SizedBox(height: 16),

              // Last 7 Days Bar Chart
              _buildBarChartCard(),
              const SizedBox(height: 16),

              // Exercise Breakdown
              if (_monthlyStats['exerciseCounts'] != null &&
                  (_monthlyStats['exerciseCounts'] as Map).isNotEmpty)
                _buildExerciseBreakdownCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddWorkout,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text('Add Workout'),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.local_fire_department,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            Text(
              '$_currentStreak',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'Day Streak',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              _currentStreak > 0
                  ? 'Keep it going!'
                  : 'Start your streak today!',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyStatsCard() {
    final monthName = DateFormat('MMMM yyyy').format(DateTime.now());
    final totalWorkouts = _monthlyStats['totalWorkouts'] ?? 0;
    final totalMinutes = _monthlyStats['totalMinutes'] ?? 0;
    final totalCalories = _monthlyStats['totalCalories'] ?? 0;
    final avgMinutes = _monthlyStats['averageMinutes'] ?? 0;
    final avgCalories = _monthlyStats['averageCalories'] ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Workouts',
                  totalWorkouts.toString(),
                  Icons.fitness_center,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Minutes',
                  totalMinutes.toString(),
                  Icons.timer,
                  Colors.green,
                ),
                _buildStatItem(
                  'Calories',
                  totalCalories.toString(),
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAvgStat('Avg Minutes', avgMinutes.toString()),
                _buildAvgStat('Avg Calories', avgCalories.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAvgStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBarChartCard() {
    final maxMinutes = _last7DaysMinutes.values.isEmpty
        ? 120.0
        : _last7DaysMinutes.values.reduce((a, b) => a > b ? a : b).toDouble();
    final chartHeight = maxMinutes == 0 ? 120.0 : maxMinutes;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  'Last 7 Days',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _last7DaysMinutes.entries.map((entry) {
                  final date = entry.key;
                  final minutes = entry.value;
                  final barHeight = chartHeight == 0
                      ? 0.0
                      : (minutes / chartHeight) * 160;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (minutes > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '$minutes',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Container(
                            height: barHeight.clamp(0.0, 160.0),
                            decoration: BoxDecoration(
                              color: minutes > 0
                                  ? Colors.deepPurple
                                  : Colors.grey[300],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('E').format(date).substring(0, 1),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseBreakdownCard() {
    final exerciseCounts = _monthlyStats['exerciseCounts'] as Map<String, int>;
    final sortedExercises = exerciseCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  'Exercise Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...sortedExercises.take(5).map((entry) {
              final total = exerciseCounts.values.reduce((a, b) => a + b);
              final percentage = (entry.value / total * 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${entry.value} workouts ($percentage%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor: Colors.grey[200],
                      color: Colors.deepPurple,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
