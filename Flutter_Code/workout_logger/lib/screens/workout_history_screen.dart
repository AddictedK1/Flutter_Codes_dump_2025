import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';
import '../services/workout_storage.dart';
import '../utils/statistics.dart';
import 'workout_entry_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final _storage = WorkoutStorage();
  List<Workout> _allWorkouts = [];
  List<Workout> _filteredWorkouts = [];
  String? _selectedExercise;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() => _isLoading = true);
    final workouts = await _storage.getWorkouts();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _allWorkouts = workouts;
      _filteredWorkouts = workouts;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredWorkouts = _allWorkouts.where((workout) {
        bool matchesExercise =
            _selectedExercise == null || workout.exercise == _selectedExercise;
        bool matchesStartDate =
            _startDate == null ||
            workout.date.isAfter(_startDate!.subtract(const Duration(days: 1)));
        bool matchesEndDate =
            _endDate == null ||
            workout.date.isBefore(_endDate!.add(const Duration(days: 1)));
        return matchesExercise && matchesStartDate && matchesEndDate;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Workouts'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exercise Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String?>(
                  value: _selectedExercise,
                  isExpanded: true,
                  hint: const Text('All Exercises'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Exercises'),
                    ),
                    ...ExerciseType.exercises.map((exercise) {
                      return DropdownMenuItem<String?>(
                        value: exercise,
                        child: Text(exercise),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setDialogState(() => _selectedExercise = value);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Date Range',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start Date'),
                  subtitle: Text(
                    _startDate != null
                        ? DateFormat('MMM dd, yyyy').format(_startDate!)
                        : 'Not set',
                  ),
                  trailing: _startDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () =>
                              setDialogState(() => _startDate = null),
                        )
                      : null,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => _startDate = date);
                    }
                  },
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End Date'),
                  subtitle: Text(
                    _endDate != null
                        ? DateFormat('MMM dd, yyyy').format(_endDate!)
                        : 'Not set',
                  ),
                  trailing: _endDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () =>
                              setDialogState(() => _endDate = null),
                        )
                      : null,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: _startDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => _endDate = date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedExercise = null;
                  _startDate = null;
                  _endDate = null;
                  _filteredWorkouts = _allWorkouts;
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _applyFilters();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteWorkout(Workout workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: const Text('Are you sure you want to delete this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.deleteWorkout(workout.id);
      _loadWorkouts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout deleted'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editWorkout(Workout workout) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutEntryScreen(workoutToEdit: workout),
      ),
    );
    if (result == true) {
      _loadWorkouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final groupedWorkouts = WorkoutStatistics.groupByWeek(_filteredWorkouts);
    final sortedWeeks = groupedWorkouts.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible:
                  _selectedExercise != null ||
                  _startDate != null ||
                  _endDate != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _filteredWorkouts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No workouts found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedExercise != null ||
                      _startDate != null ||
                      _endDate != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedExercise = null;
                          _startDate = null;
                          _endDate = null;
                          _filteredWorkouts = _allWorkouts;
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadWorkouts,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: sortedWeeks.length,
                itemBuilder: (context, index) {
                  final weekKey = sortedWeeks[index];
                  final weekWorkouts = groupedWorkouts[weekKey]!;

                  // Calculate weekly stats
                  final totalWorkouts = weekWorkouts.length;
                  final totalMinutes = weekWorkouts.fold(
                    0,
                    (sum, w) => sum + w.durationMinutes,
                  );
                  final totalCalories = weekWorkouts.fold(
                    0,
                    (sum, w) => sum + w.calories,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Summary Card
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.deepPurple[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weekKey,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatColumn(
                                    'Workouts',
                                    totalWorkouts.toString(),
                                    Icons.fitness_center,
                                  ),
                                  _buildStatColumn(
                                    'Minutes',
                                    totalMinutes.toString(),
                                    Icons.timer,
                                  ),
                                  _buildStatColumn(
                                    'Calories',
                                    totalCalories.toString(),
                                    Icons.local_fire_department,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Workout List
                      ...weekWorkouts.map(
                        (workout) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(
                                _getExerciseIcon(workout.exercise),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              workout.exercise,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy').format(workout.date),
                            ),
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${workout.durationMinutes} min',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${workout.calories} kcal',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editWorkout(workout);
                                      } else if (value == 'delete') {
                                        _deleteWorkout(workout);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  IconData _getExerciseIcon(String exercise) {
    switch (exercise.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.directions_bike;
      case 'swimming':
        return Icons.pool;
      case 'weightlifting':
        return Icons.fitness_center;
      case 'yoga':
        return Icons.self_improvement;
      case 'walking':
        return Icons.directions_walk;
      case 'boxing':
        return Icons.sports_martial_arts;
      case 'dancing':
        return Icons.music_note;
      default:
        return Icons.sports;
    }
  }
}
