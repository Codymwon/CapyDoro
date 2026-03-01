enum PomodoroPhase { idle, focus, shortBreak, longBreak, completed }

extension PomodoroPhaseExtension on PomodoroPhase {
  String get label {
    switch (this) {
      case PomodoroPhase.idle:
        return 'Ready?';
      case PomodoroPhase.focus:
        return 'Focus Time';
      case PomodoroPhase.shortBreak:
        return 'Short Break';
      case PomodoroPhase.longBreak:
        return 'Long Break';
      case PomodoroPhase.completed:
        return 'All Done!';
    }
  }

  Duration get duration {
    switch (this) {
      case PomodoroPhase.idle:
      case PomodoroPhase.completed:
        return Duration.zero;
      case PomodoroPhase.focus:
        return const Duration(minutes: 25);
      case PomodoroPhase.shortBreak:
        return const Duration(minutes: 5);
      case PomodoroPhase.longBreak:
        return const Duration(minutes: 30);
    }
  }

  /// Capybara emoticon for each state (fallback)
  String get capybaraFace {
    switch (this) {
      case PomodoroPhase.idle:
        return '(•‿•)';
      case PomodoroPhase.focus:
        return '(•ᴗ•)';
      case PomodoroPhase.shortBreak:
        return '(ᵔ◡ᵔ)';
      case PomodoroPhase.longBreak:
        return '(－‿－)';
      case PomodoroPhase.completed:
        return '(≧◡≦)';
    }
  }

  /// Asset image path for each state
  String get assetPath {
    switch (this) {
      case PomodoroPhase.idle:
        return 'Assets/idle.png';
      case PomodoroPhase.focus:
        return 'Assets/focus.png';
      case PomodoroPhase.shortBreak:
        return 'Assets/short break.png';
      case PomodoroPhase.longBreak:
        return 'Assets/long break.png';
      case PomodoroPhase.completed:
        return 'Assets/completition.png';
    }
  }
}
