import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls light / dark / system theme and remembers the user's choice.
///
/// Stored in shared_preferences so the app opens with the same theme next time.
class ThemeController extends GetxController {
  static const String _prefsKey = 'theme_mode';

  /// Current theme mode (default = follow the phone setting).
  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSaved();
  }

  /// Reads the saved theme from storage (system mode by default).
  Future<void> _loadSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_prefsKey);
    mode.value = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Changes the theme and saves the choice.
  Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      switch (newMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      },
    );
  }

  /// Cycles between Light → Dark → System (used by a single toggle button).
  Future<void> toggle() async {
    final ThemeMode next = switch (mode.value) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await setMode(next);
  }
}