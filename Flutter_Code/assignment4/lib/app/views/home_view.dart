import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/todo_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/todo_stats.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          // Theme toggle
          GetBuilder<ThemeController>(
            builder: (themeController) => IconButton(
              onPressed: () => themeController.toggleTheme(),
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ),

          // Filter button
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const FilterBottomSheet(),
              );
            },
            icon: const Icon(Icons.filter_list),
          ),

          // Settings button
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: Column(
        children: [
          // Statistics
          const TodoStats(),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: GetBuilder<TodoController>(
                  builder: (controller) => controller.searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () => controller.updateSearchQuery(''),
                          icon: const Icon(Icons.clear),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              onChanged: todoController.updateSearchQuery,
            ),
          ),

          // Todo list
          Expanded(
            child: GetBuilder<TodoController>(
              builder: (controller) {
                final filteredTodos = controller.filteredTodos;

                if (filteredTodos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_todos'.tr,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTodos[index];
                    return TodoCard(
                      todo: todo,
                      onTap: () {
                        // Show todo details in a dialog
                        _showTodoDetails(context, todo);
                      },
                      onToggle: () {
                        controller.toggleTodoCompletion(todo.id);
                      },
                      onDelete: () {
                        _showDeleteConfirmation(context, todo);
                      },
                      onEdit: () {
                        Get.toNamed(AppRoutes.editTodo, arguments: todo);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addTodo),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTodoDetails(BuildContext context, todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(todo.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description != null && todo.description!.isNotEmpty) ...[
              Text(
                'todo_description'.tr + ':',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(todo.description!),
              const SizedBox(height: 16),
            ],
            Text(
              'todo_priority'.tr + ': ${todo.priority.displayName.tr}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'todo_created'.tr + ': ${_formatDate(todo.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (todo.updatedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'todo_updated'.tr + ': ${_formatDate(todo.updatedAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_todo_title'.tr),
        content: Text('delete_todo_message'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.find<TodoController>().deleteTodo(todo.id);
              Get.back();
              Get.snackbar(
                'success'.tr,
                'todo_deleted'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
