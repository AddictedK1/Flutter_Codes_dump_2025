import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class TodoStats extends StatelessWidget {
  const TodoStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<TodoController>(
      builder: (todoController) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _StatItem(
                  title: 'total_todos'.tr,
                  value: todoController.totalTodos.toString(),
                  icon: Icons.list_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _StatItem(
                  title: 'completed_todos'.tr,
                  value: todoController.completedTodos.toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _StatItem(
                  title: 'pending_todos'.tr,
                  value: todoController.pendingTodos.toString(),
                  icon: Icons.schedule_outlined,
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _StatItem(
                  title: 'high_priority_todos'.tr,
                  value: todoController.highPriorityTodos.toString(),
                  icon: Icons.priority_high_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
