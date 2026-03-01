import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/pomodoro_state.dart';

class SessionDots extends StatelessWidget {
  final int completedSessions;
  final PomodoroPhase phase;

  const SessionDots({
    super.key,
    required this.completedSessions,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isCompleted = index < completedSessions;
        final isActive =
            index == completedSessions && phase == PomodoroPhase.focus;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 14 : 10,
          height: isActive ? 14 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.focus
                : isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            border: isActive
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
        );
      }),
    );
  }
}
