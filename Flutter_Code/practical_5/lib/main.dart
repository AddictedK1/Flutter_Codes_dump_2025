import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Todo Model
class Todo {
  final String id;
  final String title;
  bool isCompleted;

  Todo({required this.id, required this.title, this.isCompleted = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Todo> _todos = [];
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  // Get filtered todos based on tab
  List<Todo> get _allTodos => _todos;
  List<Todo> get _pendingTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();
  List<Todo> get _completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  // Add todo
  void _addTodo() {
    if (_todoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a todo title')),
      );
      return;
    }

    setState(() {
      _todos.add(
        Todo(id: DateTime.now().toString(), title: _todoController.text.trim()),
      );
      _todoController.clear();
    });
    Navigator.of(context).pop();
  }

  // Delete todo
  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  // Toggle complete status
  void _toggleComplete(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = !todo.isCompleted;
    });
  }

  // Show add todo dialog
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: TextField(
            controller: _todoController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter todo title',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addTodo(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _todoController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
          ],
        );
      },
    );
  }

  // Build todo list
  Widget _buildTodoList(List<Todo> todos) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No todos yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => _toggleComplete(todo.id),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo.id),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.list)),
            Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodoList(_allTodos),
          _buildTodoList(_pendingTodos),
          _buildTodoList(_completedTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
