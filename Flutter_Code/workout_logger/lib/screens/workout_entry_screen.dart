import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/workout_storage.dart';

class WorkoutEntryScreen extends StatefulWidget {
  final Workout? workoutToEdit;

  const WorkoutEntryScreen({super.key, this.workoutToEdit});

  @override
  State<WorkoutEntryScreen> createState() => _WorkoutEntryScreenState();
}

class _WorkoutEntryScreenState extends State<WorkoutEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _storage = WorkoutStorage();

  String _selectedExercise = ExerciseType.exercises[0];
  double _durationMinutes = 30.0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.workoutToEdit != null) {
      _selectedExercise = widget.workoutToEdit!.exercise;
      _durationMinutes = widget.workoutToEdit!.durationMinutes.toDouble();
      _caloriesController.text = widget.workoutToEdit!.calories.toString();
      _selectedDate = widget.workoutToEdit!.date;
    }
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final calories = int.tryParse(_caloriesController.text) ?? 0;

      final workout = Workout(
        id:
            widget.workoutToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        exercise: _selectedExercise,
        durationMinutes: _durationMinutes.toInt(),
        calories: calories,
        date: _selectedDate,
      );

      if (widget.workoutToEdit != null) {
        await _storage.updateWorkout(workout);
      } else {
        await _storage.saveWorkout(workout);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.workoutToEdit != null
                  ? 'Workout updated successfully!'
                  : 'Workout saved successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workoutToEdit != null ? 'Edit Workout' : 'Add Workout',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Exercise Type Dropdown
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exercise Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedExercise,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ExerciseType.exercises.map((exercise) {
                          return DropdownMenuItem(
                            value: exercise,
                            child: Text(exercise),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExercise = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Selection
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text(
                    'Workout Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple,
                  ),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 16),

              // Duration Slider
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            '${_durationMinutes.toInt()} minutes',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _durationMinutes,
                        min: 0,
                        max: 120,
                        divisions: 24,
                        label: '${_durationMinutes.toInt()} min',
                        activeColor: Colors.deepPurple,
                        onChanged: (value) {
                          setState(() {
                            _durationMinutes = value;
                          });
                        },
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0 min', style: TextStyle(color: Colors.grey)),
                          Text('120 min', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Calories Text Field
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calories Burned',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter calories burned',
                          suffixText: 'kcal',
                          prefixIcon: Icon(
                            Icons.local_fire_department,
                            color: Colors.deepOrange,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter calories burned';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (int.parse(value) < 0) {
                            return 'Calories must be positive';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.workoutToEdit != null
                      ? 'Update Workout'
                      : 'Save Workout',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
