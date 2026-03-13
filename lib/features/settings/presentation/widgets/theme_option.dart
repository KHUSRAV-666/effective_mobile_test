part of '../screens/settings_screen.dart';

class ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode currentThemeMode;

  const ThemeOption({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        side: BorderSide(
          color: currentThemeMode == value
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withAlpha(50),
        ),
      ),
      child: RadioListTile<ThemeMode>(
        value: value,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSpacing.s),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: currentThemeMode == value ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      ),
    );
  }
}
