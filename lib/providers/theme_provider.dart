import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'settings_provider.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsProvider _settings;

  ThemeProvider(this._settings);

  bool get isDarkMode {
    // Fall back to settings
    if (_settings.themeMode == 'dark') return true;
    if (_settings.themeMode == 'light') return false;

    // Fall back to system default
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  ThemeMode get themeMode {
    if (_settings.themeMode == 'dark') return ThemeMode.dark;
    if (_settings.themeMode == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggle() {
    if (isDarkMode) {
      _settings.setThemeMode('light');
    } else {
      _settings.setThemeMode('dark');
    }
    notifyListeners();
  }

  void updateTheme() {
    notifyListeners();
  }
}
