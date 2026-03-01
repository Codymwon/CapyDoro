import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/pomodoro_state.dart';

class TimerRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final PomodoroPhase phase;
  final String timeText;
  final Widget child;

  const TimerRing({
    super.key,
    required this.progress,
    required this.phase,
    required this.timeText,
    required this.child,
  });

  @override
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _ringColorAnim;
  late Animation<Color?> _trackColorAnim;
  Color _currentRingColor = AppColors.primary;
  Color _currentTrackColor = AppColors.primary.withValues(alpha: 0.18);

  Color _ringColorForPhase(PomodoroPhase phase) {
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
  void initState() {
    super.initState();
    _currentRingColor = _ringColorForPhase(widget.phase);
    _currentTrackColor = _currentRingColor.withValues(alpha: 0.18);
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _ringColorAnim = AlwaysStoppedAnimation(_currentRingColor);
    _trackColorAnim = AlwaysStoppedAnimation(_currentTrackColor);
  }

  @override
  void didUpdateWidget(TimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) {
      final newRing = _ringColorForPhase(widget.phase);
      final newTrack = newRing.withValues(alpha: 0.18);
      _ringColorAnim = ColorTween(begin: _currentRingColor, end: newRing)
          .animate(
            CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
          );
      _trackColorAnim = ColorTween(begin: _currentTrackColor, end: newTrack)
          .animate(
            CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
          );
      _colorController.forward(from: 0).then((_) {
        _currentRingColor = newRing;
        _currentTrackColor = newTrack;
      });
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorController,
      builder: (context, child) {
        return CustomPaint(
          painter: _TimerRingPainter(
            progress: widget.progress,
            ringColor: _ringColorAnim.value ?? _currentRingColor,
            trackColor: _trackColorAnim.value ?? _currentTrackColor,
          ),
          child: Center(child: widget.child),
        );
      },
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;

  _TimerRingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;
    const strokeWidth = 12.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.trackColor != trackColor;
  }
}
