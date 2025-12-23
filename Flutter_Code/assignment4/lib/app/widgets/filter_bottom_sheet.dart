import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('filter'.tr, style: theme.textTheme.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () {
                  todoController.clearFilters();
                  Get.back();
                },
                child: Text('clear_filters'.tr),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Show completed toggle
          GetBuilder<TodoController>(
            builder: (controller) => SwitchListTile(
              title: Text(
                controller.showCompleted
                    ? 'show_completed'.tr
                    : 'hide_completed'.tr,
              ),
              subtitle: Text(
                controller.showCompleted
                    ? 'Completed todos are visible'
                    : 'Completed todos are hidden',
              ),
              value: controller.showCompleted,
              onChanged: (_) => controller.toggleShowCompleted(),
            ),
          ),

          const SizedBox(height: 16),

          // Priority filter
          Text('todo_priority'.tr, style: theme.textTheme.titleMedium),

          const SizedBox(height: 12),

          GetBuilder<TodoController>(
            builder: (controller) => Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text('all_priorities'.tr),
                  selected: controller.selectedPriority == null,
                  onSelected: (_) => controller.setSelectedPriority(null),
                ),
                FilterChip(
                  label: Text('priority_high'.tr),
                  selected: controller.selectedPriority == Priority.high,
                  onSelected: (_) =>
                      controller.setSelectedPriority(Priority.high),
                ),
                FilterChip(
                  label: Text('priority_medium'.tr),
                  selected: controller.selectedPriority == Priority.medium,
                  onSelected: (_) =>
                      controller.setSelectedPriority(Priority.medium),
                ),
                FilterChip(
                  label: Text('priority_low'.tr),
                  selected: controller.selectedPriority == Priority.low,
                  onSelected: (_) =>
                      controller.setSelectedPriority(Priority.low),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
