import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/pomodoro_state.dart';

class TimerProvider extends ChangeNotifier {
  PomodoroPhase _phase = PomodoroPhase.idle;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  int _sessionCount = 0; // completed focus sessions (0–4)
  bool _isRunning = false;
  Timer? _timer;

  // Getters
  PomodoroPhase get phase => _phase;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  int get sessionCount => _sessionCount;
  bool get isRunning => _isRunning;
  int get completedSessions => _sessionCount;

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
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _onPhaseComplete();
      }
    });
  }

  /// Pause the timer
  void pause() {
    _timer?.cancel();
    _isRunning = false;
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
    _setDuration(_phase.duration);
  }

  void _setDuration(Duration duration) {
    _totalSeconds = duration.inSeconds;
    _remainingSeconds = _totalSeconds;
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    _isRunning = false;

    switch (_phase) {
      case PomodoroPhase.focus:
        _sessionCount++;
        if (_sessionCount >= 4) {
          // After 4 focus sessions → long break
          _phase = PomodoroPhase.longBreak;
          _setDuration(_phase.duration);
        } else {
          // Short break
          _phase = PomodoroPhase.shortBreak;
          _setDuration(_phase.duration);
        }
        // Auto-start the break
        notifyListeners();
        start();
        break;

      case PomodoroPhase.shortBreak:
        // Back to focus
        _phase = PomodoroPhase.focus;
        _setDuration(_phase.duration);
        notifyListeners();
        start();
        break;

      case PomodoroPhase.longBreak:
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
    super.dispose();
  }
}
