import 'package:effective_mobile_test/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final isDark = themeNotifier.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Внешний вид'),
          const SizedBox(height: 8),
          _buildThemeOption(
            context,
            title: 'Светлый режим',
            icon: Icons.light_mode,
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) => themeNotifier.setTheme(mode!),
          ),
          _buildThemeOption(
            context,
            title: 'Темный режим',
            icon: Icons.dark_mode,
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) => themeNotifier.setTheme(mode!),
          ),
          _buildThemeOption(
            context,
            title: 'Системный',
            icon: Icons.settings,
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) => themeNotifier.setTheme(mode!),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
    required void Function(ThemeMode?) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<ThemeMode>(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
