import 'package:flutter/material.dart';
import 'models/task.dart';
import 'services/task_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

enum TaskFilter { all, active, completed }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();

  List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  bool _isMultiSelectMode = false;
  Set<String> _selectedTaskIds = {};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  // Load tasks from storage
  Future<void> _loadTasks() async {
    final tasks = await _taskService.loadTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  // Save tasks to storage
  Future<void> _saveTasks() async {
    await _taskService.saveTasks(_tasks);
  }

  // Add new task
  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;

    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _taskController.text.trim(),
        ),
      );
    });
    _taskController.clear();
    _saveTasks();
  }

  // Delete task with undo
  void _deleteTask(Task task, int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();

    // Show SnackBar with Undo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
            _saveTasks();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Toggle task completion
  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  // Toggle task importance
  void _toggleTaskImportance(Task task) {
    setState(() {
      task.isImportant = !task.isImportant;
    });
    _saveTasks();
  }

  // Handle long press - toggle importance or enter multi-select mode
  void _handleLongPress(Task task) {
    if (!_isMultiSelectMode) {
      // First long press - toggle importance
      _toggleTaskImportance(task);

      // Enter multi-select mode
      setState(() {
        _isMultiSelectMode = true;
        _selectedTaskIds.add(task.id);
      });
    }
  }

  // Toggle task selection in multi-select mode
  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTaskIds.contains(taskId)) {
        _selectedTaskIds.remove(taskId);
        if (_selectedTaskIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedTaskIds.add(taskId);
      }
    });
  }

  // Delete selected tasks
  void _deleteSelectedTasks() {
    final tasksToDelete = _tasks
        .where((task) => _selectedTaskIds.contains(task.id))
        .toList();

    setState(() {
      _tasks.removeWhere((task) => _selectedTaskIds.contains(task.id));
      _selectedTaskIds.clear();
      _isMultiSelectMode = false;
    });
    _saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${tasksToDelete.length} task(s) deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _tasks.addAll(tasksToDelete);
            });
            _saveTasks();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Cancel multi-select mode
  void _cancelMultiSelect() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedTaskIds.clear();
    });
  }

  // Get filtered tasks
  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: _isMultiSelectMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _selectedTaskIds.isNotEmpty
                      ? _deleteSelectedTasks
                      : null,
                  tooltip: 'Delete selected',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _cancelMultiSelect,
                  tooltip: 'Cancel',
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All', TaskFilter.all),
                const SizedBox(width: 8),
                _buildFilterButton('Active', TaskFilter.active),
                const SizedBox(width: 8),
                _buildFilterButton('Completed', TaskFilter.completed),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Text(
                      _currentFilter == TaskFilter.all
                          ? 'No tasks yet. Add one below!'
                          : 'No ${_currentFilter.name} tasks',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final originalIndex = _tasks.indexOf(task);

                      return Dismissible(
                        key: Key(task.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _deleteTask(task, originalIndex);
                        },
                        child: _buildTaskTile(task),
                      );
                    },
                  ),
          ),

          // Add task input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _addTask,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build filter button
  Widget _buildFilterButton(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Text(label),
    );
  }

  // Build task list tile
  Widget _buildTaskTile(Task task) {
    final isSelected = _selectedTaskIds.contains(task.id);

    return ListTile(
      leading: _isMultiSelectMode
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleTaskSelection(task.id),
            )
          : Checkbox(
              value: task.isCompleted,
              onChanged: (_) => _toggleTaskCompletion(task),
            ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : null,
        ),
      ),
      trailing: task.isImportant
          ? const Icon(Icons.star, color: Colors.amber)
          : null,
      onTap: _isMultiSelectMode
          ? () => _toggleTaskSelection(task.id)
          : () => _toggleTaskCompletion(task),
      onLongPress: () => _handleLongPress(task),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
