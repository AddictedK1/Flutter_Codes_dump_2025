import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_todo'.tr),
        actions: [TextButton(onPressed: _saveTodo, child: Text('save'.tr))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'todo_title'.tr,
                  hintText: 'Enter todo title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'enter_title'.tr;
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'todo_description'.tr,
                  hintText: 'Enter todo description (optional)',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 24),

              // Priority selection
              Text(
                'todo_priority'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              Row(
                children: Priority.values.map((priority) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(priority.displayName.tr),
                        selected: _selectedPriority == priority,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTodo,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('save'.tr),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTodo() {
    if (_formKey.currentState?.validate() ?? false) {
      final todoController = Get.find<TodoController>();

      todoController.addTodo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        priority: _selectedPriority,
      );

      Get.back();
      Get.snackbar(
        'success'.tr,
        'todo_added'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
