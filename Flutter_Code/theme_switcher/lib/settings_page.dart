import 'package:flutter/material.dart';
import 'themes.dart';

class SettingsPage extends StatelessWidget {
  final AppTheme currentTheme;
  final Function(AppTheme) onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildThemeOption(
                      context,
                      AppTheme.light,
                      'Light Theme',
                      'Clean and bright interface',
                      Icons.wb_sunny,
                    ),
                    const Divider(),
                    _buildThemeOption(
                      context,
                      AppTheme.dark,
                      'Dark Theme',
                      'Easy on the eyes in low light',
                      Icons.nightlight_round,
                    ),
                    const Divider(),
                    _buildThemeOption(
                      context,
                      AppTheme.customBlue,
                      'Custom Blue Theme',
                      'Soothing blue color palette',
                      Icons.palette,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Preview',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildColorPreview(
                      context,
                      'Primary Color',
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    _buildColorPreview(
                      context,
                      'Secondary Color',
                      Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 8),
                    _buildColorPreview(
                      context,
                      'Background Color',
                      Theme.of(context).colorScheme.background,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppTheme theme,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = currentTheme == theme;

    return InkWell(
      onTap: () => onThemeChanged(theme),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Radio<AppTheme>(
              value: theme,
              groupValue: currentTheme,
              onChanged: (AppTheme? value) {
                if (value != null) {
                  onThemeChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPreview(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
