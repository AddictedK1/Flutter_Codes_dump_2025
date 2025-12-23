import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/language_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('app_settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('theme'.tr, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  GetBuilder<ThemeController>(
                    builder: (controller) => SwitchListTile(
                      title: Text(
                        controller.isDarkMode
                            ? 'dark_mode'.tr
                            : 'light_mode'.tr,
                      ),
                      subtitle: Text(
                        controller.isDarkMode
                            ? 'Dark theme is enabled'
                            : 'Light theme is enabled',
                      ),
                      value: controller.isDarkMode,
                      onChanged: (_) => controller.toggleTheme(),
                      secondary: Icon(
                        controller.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Language Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('language'.tr, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  GetBuilder<LanguageController>(
                    builder: (controller) => Column(
                      children: controller.supportedLocales.map((locale) {
                        final isSelected =
                            controller.currentLocale.languageCode ==
                            locale.languageCode;
                        return RadioListTile<Locale>(
                          title: Text(
                            controller.getLanguageName(locale.languageCode),
                          ),
                          subtitle: Text(locale.languageCode.toUpperCase()),
                          value: locale,
                          groupValue: controller.currentLocale,
                          onChanged: (locale) {
                            if (locale != null) {
                              controller.changeLanguage(locale);
                            }
                          },
                          secondary: Icon(
                            isSelected ? Icons.check_circle : Icons.language,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App Information Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Information', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.code),
                    title: Text('Built with'),
                    subtitle: Text('Flutter & GetX'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Theme'),
                    subtitle: Text('Material Design 3'),
                    trailing: Icon(
                      Icons.color_lens,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
