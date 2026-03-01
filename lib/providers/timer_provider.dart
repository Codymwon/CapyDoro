import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import '../models/pomodoro_state.dart';
import 'settings_provider.dart';
import '../services/audio_service.dart';

class TimerProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  PomodoroPhase _phase = PomodoroPhase.idle;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _sessionCount = 0; // completed focus sessions
  bool _isRunning = false;
  Timer? _timer;
  DateTime? _endTime;

  TimerProvider(this._settings) {
    _setDurationForPhase(_phase);
    _settings.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    if (_phase == PomodoroPhase.idle) {
      _setDurationForPhase(_phase);
      notifyListeners();
    }
  }

  // Getters
  PomodoroPhase get phase => _phase;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get sessionCount => _sessionCount;
  bool get isRunning => _isRunning;
  int get completedSessions => _sessionCount;
  DateTime? get endTime => _endTime;

  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  String get timeDisplay {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Start/resume the timer
  void start() {
    if (_phase == PomodoroPhase.idle || _phase == PomodoroPhase.completed) {
      _startFocusSession();
    }

    if (_remainingSeconds <= 0) return;

    _isRunning = true;
    _endTime = DateTime.now().add(Duration(seconds: _remainingSeconds));
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    if (_endTime == null) return;

    final remaining = _endTime!.difference(DateTime.now()).inSeconds;

    if (remaining > 0) {
      _remainingSeconds = remaining;
      notifyListeners();
    } else {
      _onPhaseComplete();
    }
  }

  /// Pause the timer
  void pause() {
    _timer?.cancel();
    _isRunning = false;

    if (_endTime != null) {
      // Recalculate precisely how much is left so we can resume accurately
      final diff = _endTime!.difference(DateTime.now()).inSeconds;
      _remainingSeconds = diff > 0 ? diff : 0;
      _endTime = null;
    }

    notifyListeners();
  }

  /// Skip to the next phase
  void skip() {
    _timer?.cancel();
    _isRunning = false;
    _onPhaseComplete();
  }

  /// Reset everything back to idle
  void reset() {
    _timer?.cancel();
    _phase = PomodoroPhase.idle;
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _sessionCount = 0;
    _isRunning = false;
    notifyListeners();
  }

  void _startFocusSession() {
    _phase = PomodoroPhase.focus;
    _setDurationForPhase(_phase);
  }

  void _setDurationForPhase(PomodoroPhase phase) {
    int minutes;
    switch (phase) {
      case PomodoroPhase.focus:
      case PomodoroPhase.idle:
        minutes = _settings.focusDuration;
        break;
      case PomodoroPhase.shortBreak:
        minutes = _settings.shortBreakDuration;
        break;
      case PomodoroPhase.longBreak:
        minutes = _settings.longBreakDuration;
        break;
      case PomodoroPhase.completed:
        minutes = 0;
        break;
    }
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    _isRunning = false;

    switch (_phase) {
      case PomodoroPhase.focus:
        _sessionCount++;

        // Play sound for finishing focus and entering break
        if (_settings.soundEnabled) {
          AudioService().playWorkToBreak();
        }
        if (_settings.vibrateEnabled) {
          Vibration.vibrate(pattern: [0, 500, 200, 500]);
        }

        if (_sessionCount >= _settings.longBreakInterval) {
          // After required focus sessions → long break
          _phase = PomodoroPhase.longBreak;
          _setDurationForPhase(_phase);
        } else {
          // Short break
          _phase = PomodoroPhase.shortBreak;
          _setDurationForPhase(_phase);
        }

        notifyListeners();
        if (_settings.autoStartBreaks) {
          start();
        }
        break;

      case PomodoroPhase.shortBreak:
        if (_settings.soundEnabled) {
          AudioService().playBreakToWork();
        }
        if (_settings.vibrateEnabled) {
          Vibration.vibrate(pattern: [0, 500, 200, 500]);
        }

        // Back to focus
        _phase = PomodoroPhase.focus;
        _setDurationForPhase(_phase);

        notifyListeners();
        if (_settings.autoStartFocus) {
          start();
        }
        break;

      case PomodoroPhase.longBreak:
        if (_settings.soundEnabled) {
          AudioService().playCompletion();
        }
        if (_settings.vibrateEnabled) {
          Vibration.vibrate(pattern: [0, 500, 200, 500]);
        }

        // All done!
        _phase = PomodoroPhase.completed;
        _remainingSeconds = 0;
        _totalSeconds = 0;
        _sessionCount = 0;
        notifyListeners();
        break;

      case PomodoroPhase.idle:
      case PomodoroPhase.completed:
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
