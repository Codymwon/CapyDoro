import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/pomodoro_state.dart';

class TimerBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final PomodoroPhase phase;

  const TimerBar({super.key, required this.progress, required this.phase});

  Color get _barColor {
    switch (phase) {
      case PomodoroPhase.focus:
        return AppColors.focus;
      case PomodoroPhase.shortBreak:
      case PomodoroPhase.longBreak:
        return AppColors.breakColor;
      case PomodoroPhase.idle:
        return AppColors.primary;
      case PomodoroPhase.completed:
        return AppColors.focus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      height: 10,
      decoration: BoxDecoration(
        color: _barColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                width: constraints.maxWidth * progress,
                height: 10,
                decoration: BoxDecoration(
                  color: _barColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
