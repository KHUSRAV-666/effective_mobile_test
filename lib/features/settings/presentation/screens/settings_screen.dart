import 'package:effective_mobile_test/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:effective_mobile_test/core/theme/app_spacing.dart';

part '../widgets/theme_option.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Внешний вид'),
          const SizedBox(height: 8),

          RadioGroup<ThemeMode>(
            onChanged: (mode) => themeNotifier.setTheme(mode!),
            groupValue: themeMode,
            child: Column(
              children: [
                ThemeOption(
                  title: 'Светлый режим',
                  icon: Icons.light_mode,
                  value: ThemeMode.light,
                  currentThemeMode: themeMode,
                ),
                ThemeOption(
                  title: 'Темный режим',
                  icon: Icons.dark_mode,
                  value: ThemeMode.dark,
                  currentThemeMode: themeMode,
                ),
                ThemeOption(
                  title: 'Системный',
                  icon: Icons.settings,
                  value: ThemeMode.system,
                  currentThemeMode: themeMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
