import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/add_todo_view.dart';
import '../views/edit_todo_view.dart';
import '../views/settings_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.addTodo, page: () => const AddTodoView()),
    GetPage(name: AppRoutes.editTodo, page: () => const EditTodoView()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
  ];
}
