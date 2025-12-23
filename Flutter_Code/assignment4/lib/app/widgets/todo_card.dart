import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../themes/app_themes.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppThemes.getPriorityColor(todo.priority.name),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      todo.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.isCompleted
                            ? theme.colorScheme.onSurface.withOpacity(0.6)
                            : null,
                      ),
                    ),
                  ),

                  // Checkbox
                  Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => onToggle(),
                  ),
                ],
              ),

              if (todo.description != null && todo.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  todo.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  // Priority chip
                  Chip(
                    label: Text(
                      todo.priority.displayName.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: AppThemes.getPriorityColor(
                      todo.priority.name,
                    ).withOpacity(0.1),
                    side: BorderSide(
                      color: AppThemes.getPriorityColor(todo.priority.name),
                    ),
                  ),

                  const Spacer(),

                  // Action buttons
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: 20,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    visualDensity: VisualDensity.compact,
                    color: theme.colorScheme.error,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Created date
              Text(
                '${'todo_created'.tr}: ${_formatDate(todo.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
