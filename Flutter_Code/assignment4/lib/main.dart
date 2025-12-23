import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/controllers/theme_controller.dart';
import 'app/controllers/language_controller.dart';
import 'app/controllers/todo_controller.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/app_translations.dart';
import 'app/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize controllers
  await Get.putAsync<ThemeController>(() async {
    final controller = ThemeController();
    await controller.loadTheme();
    return controller;
  });

  await Get.putAsync<LanguageController>(() async {
    final controller = LanguageController();
    await controller.loadLanguage();
    return controller;
  });

  Get.put(TodoController());

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LanguageController>(
          builder: (languageController) {
            return GetMaterialApp(
              title: 'Todo App',
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeController.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
              locale: languageController.currentLocale,
              fallbackLocale: const Locale('en', 'US'),
              translations: AppTranslations(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('es', 'ES'),
                Locale('fr', 'FR'),
                Locale('ar', 'SA'),
              ],
              initialRoute: AppRoutes.home,
              getPages: AppPages.pages,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
