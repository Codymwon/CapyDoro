import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Durations (in minutes)
  late int _focusDuration;
  late int _shortBreakDuration;
  late int _longBreakDuration;

  // Cycles
  late int _longBreakInterval;

  // Automation
  late bool _autoStartBreaks;
  late bool _autoStartFocus;

  // Notifications
  late bool _soundEnabled;
  late bool _vibrateEnabled;

  // Theme
  late String _themeMode; // 'system', 'light', 'dark'

  // Getters
  int get focusDuration => _focusDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  int get longBreakInterval => _longBreakInterval;
  bool get autoStartBreaks => _autoStartBreaks;
  bool get autoStartFocus => _autoStartFocus;
  bool get soundEnabled => _soundEnabled;
  bool get vibrateEnabled => _vibrateEnabled;
  String get themeMode => _themeMode;

  SettingsProvider(this._prefs) {
    _focusDuration = _prefs.getInt('focusDuration') ?? 25;
    _shortBreakDuration = _prefs.getInt('shortBreakDuration') ?? 5;
    _longBreakDuration = _prefs.getInt('longBreakDuration') ?? 30;

    _longBreakInterval = _prefs.getInt('longBreakInterval') ?? 4;

    _autoStartBreaks = _prefs.getBool('autoStartBreaks') ?? false;
    _autoStartFocus = _prefs.getBool('autoStartFocus') ?? false;

    _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
    _vibrateEnabled = _prefs.getBool('vibrateEnabled') ?? false;

    _themeMode = _prefs.getString('themeMode') ?? 'system';
  }

  // Setters
  Future<void> setFocusDuration(int minutes) async {
    _focusDuration = minutes;
    await _prefs.setInt('focusDuration', minutes);
    notifyListeners();
  }

  Future<void> setShortBreakDuration(int minutes) async {
    _shortBreakDuration = minutes;
    await _prefs.setInt('shortBreakDuration', minutes);
    notifyListeners();
  }

  Future<void> setLongBreakDuration(int minutes) async {
    _longBreakDuration = minutes;
    await _prefs.setInt('longBreakDuration', minutes);
    notifyListeners();
  }

  Future<void> setLongBreakInterval(int count) async {
    _longBreakInterval = count;
    await _prefs.setInt('longBreakInterval', count);
    notifyListeners();
  }

  Future<void> setAutoStartBreaks(bool value) async {
    _autoStartBreaks = value;
    await _prefs.setBool('autoStartBreaks', value);
    notifyListeners();
  }

  Future<void> setAutoStartFocus(bool value) async {
    _autoStartFocus = value;
    await _prefs.setBool('autoStartFocus', value);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _prefs.setString('themeMode', mode);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  Future<void> setVibrateEnabled(bool value) async {
    _vibrateEnabled = value;
    await _prefs.setBool('vibrateEnabled', value);
    notifyListeners();
  }
}
