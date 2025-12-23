import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'themes.dart';

class HomePage extends StatelessWidget {
  final AppTheme currentTheme;
  final Function(AppTheme) onThemeChanged;

  const HomePage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Theme Switcher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentTheme: currentTheme,
                    onThemeChanged: onThemeChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Welcome!',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This app demonstrates a multi-theme system with three beautiful themes to choose from.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Theme: ${AppThemes.getThemeName(currentTheme)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Theme Colors Section
            Text(
              'Theme Colors',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildColorRow(
                      context,
                      'Primary',
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildColorRow(
                      context,
                      'Secondary',
                      Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    _buildColorRow(
                      context,
                      'Background',
                      Theme.of(context).colorScheme.background,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons Section
            Text(
              'Button Styles',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showSnackBar(context, 'Elevated Button Pressed!');
                      },
                      child: const Text('Elevated Button'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        _showSnackBar(context, 'Outlined Button Pressed!');
                      },
                      child: const Text('Outlined Button'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        _showSnackBar(context, 'Text Button Pressed!');
                      },
                      child: const Text('Text Button'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feature Cards
            Text(
              'Feature Highlights',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              'Instant Theme Switching',
              'Change themes on-the-fly with immediate visual feedback.',
              Icons.flash_on,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              'Persistent Storage',
              'Your theme preference is saved and restored automatically.',
              Icons.save,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              context,
              'Custom Color Schemes',
              'Each theme features carefully crafted color palettes.',
              Icons.color_lens,
            ),
            const SizedBox(height: 24),

            // Text Styles Section
            Text('Typography', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Display Large',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Divider(),
                    Text(
                      'Display Medium',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const Divider(),
                    Text(
                      'Display Small',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const Divider(),
                    Text(
                      'Headline Medium',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Divider(),
                    Text(
                      'Body Large - The quick brown fox jumps over the lazy dog.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(),
                    Text(
                      'Body Medium - The quick brown fox jumps over the lazy dog.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Theme Switcher
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Quick Theme Switch',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickThemeButton(
                          context,
                          AppTheme.light,
                          Icons.wb_sunny,
                          'Light',
                        ),
                        _buildQuickThemeButton(
                          context,
                          AppTheme.dark,
                          Icons.nightlight_round,
                          'Dark',
                        ),
                        _buildQuickThemeButton(
                          context,
                          AppTheme.customBlue,
                          Icons.palette,
                          'Blue',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(
                currentTheme: currentTheme,
                onThemeChanged: onThemeChanged,
              ),
            ),
          );
        },
        icon: const Icon(Icons.settings),
        label: const Text('Theme Settings'),
      ),
    );
  }

  Widget _buildColorRow(BuildContext context, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickThemeButton(
    BuildContext context,
    AppTheme theme,
    IconData icon,
    String label,
  ) {
    final isActive = currentTheme == theme;
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 36,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          onPressed: () => onThemeChanged(theme),
          style: IconButton.styleFrom(
            backgroundColor: isActive
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
