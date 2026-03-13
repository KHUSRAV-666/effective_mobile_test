import 'package:effective_mobile_test/core/store/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier(ThemeMode.system);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(super.initialMode);

  final _db = CharacterDb.instance;

  Future<void> setTheme(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await _db.saveSetting('theme_mode', mode.index);
  }
}
