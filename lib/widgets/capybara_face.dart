import 'package:flutter/material.dart';
import '../models/pomodoro_state.dart';

class CapybaraFace extends StatelessWidget {
  final PomodoroPhase phase;

  const CapybaraFace({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      // Force both old and new children into the same layout box
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: Image.asset(
        phase.assetPath,
        key: ValueKey(phase),
        fit: BoxFit.contain,
        // Fill the parent SizedBox completely — all images same size
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
