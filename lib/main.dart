import 'package:effective_mobile_test/core/router/app_router.dart';
import 'package:effective_mobile_test/core/store/database_helper.dart';
import 'package:effective_mobile_test/core/theme/app_theme.dart';
import 'package:effective_mobile_test/shared/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = CharacterDb.instance;
  await db.database;

  final savedThemeIndex = await db.getIntSetting('theme_mode') ?? 2;
  final initialTheme = ThemeMode.values[savedThemeIndex];

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => ThemeNotifier(initialTheme)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Rick & Morty App',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
