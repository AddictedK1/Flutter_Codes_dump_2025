import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.put(ExpenseController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Expenses'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Total Expense Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    '₹${controller.totalExpenses.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expenses List
          Expanded(
            child: Obx(() {
              if (controller.expenses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No expenses yet!',
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tap + to add your first expense',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.expenses.length,
                itemBuilder: (context, index) {
                  final expense = controller.expenses[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Leading Icon
                          CircleAvatar(
                            backgroundColor: _getCategoryColor(
                              expense.category,
                            ),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  expense.category,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                if (expense.description != null &&
                                    expense.description!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      expense.description!,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy - hh:mm a',
                                  ).format(expense.date),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Trailing - Amount and Delete
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${expense.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  _showDeleteDialog(
                                    context,
                                    controller,
                                    expense.id,
                                  );
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddExpenseScreen());
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ExpenseController controller,
    String id,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteExpense(id);
              Get.back();
              Get.snackbar(
                'Success',
                'Expense deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Shopping':
        return Colors.purple;
      case 'Entertainment':
        return Colors.pink;
      case 'Bills':
        return Colors.red;
      case 'Health':
        return Colors.green;
      case 'Education':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Entertainment':
        return Icons.movie;
      case 'Bills':
        return Icons.receipt;
      case 'Health':
        return Icons.local_hospital;
      case 'Education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
