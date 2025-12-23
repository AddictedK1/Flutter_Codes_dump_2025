import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Fake sample tasks for UI only
  final List<String> _sampleTasks = [
    'Task 1',
    'Task 2',
    'Task 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Your Task:"),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _sampleTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_sampleTasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {}, // No functionality
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {}, // No functionality
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
