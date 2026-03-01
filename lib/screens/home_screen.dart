import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pomodoro_state.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_ring.dart';
import '../widgets/capybara_face.dart';
import '../widgets/action_button.dart';
import '../widgets/session_dots.dart';
import '../widgets/timer_bar.dart';
import '../main.dart' show themeProvider;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TimerProvider _timer = TimerProvider();

  @override
  void initState() {
    super.initState();
    _timer.addListener(_onTimerUpdate);
  }

  void _onTimerUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    _timer.removeListener(_onTimerUpdate);
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? 48 : 32,
                  vertical: isLandscape ? 16 : 0,
                ),
                child: isLandscape ? _buildLandscape() : _buildPortrait(),
              ),
            ),
            _buildThemeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).colorScheme.secondary;

    return Positioned(
      top: 12,
      right: 16,
      child: GestureDetector(
        onTap: () => themeProvider.toggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween(begin: 0.75, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(isDark),
              size: 22,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        _buildHeader(),
        const SizedBox(height: 12),
        SessionDots(
          completedSessions: _timer.completedSessions,
          phase: _timer.phase,
        ),
        const Spacer(flex: 1),
        _buildTimerRing(260),
        const Spacer(flex: 1),
        _buildActionButtons(),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildLandscape() {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side: capybara + timer + progress bar
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CapybaraFace(phase: _timer.phase),
              ),
              const SizedBox(height: 12),
              Text(
                _timer.phase == PomodoroPhase.idle
                    ? '25:00'
                    : _timer.phase == PomodoroPhase.completed
                    ? '00:00'
                    : _timer.timeDisplay,
                style: GoogleFonts.nunito(
                  fontSize: 52,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TimerBar(progress: _timer.progress, phase: _timer.phase),
              ),
            ],
          ),
        ),
        // Right side: phase label, dots, buttons
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _timer.phase.label,
                  key: ValueKey(_timer.phase),
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SessionDots(
                completedSessions: _timer.completedSessions,
                phase: _timer.phase,
              ),
              const SizedBox(height: 28),
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CapyDoro',
          style: GoogleFonts.nunito(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.secondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            _timer.phase.label,
            key: ValueKey(_timer.phase),
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerRing(double size) {
    final imgSize = size * 0.42;
    final fontSize = size > 200 ? 44.0 : 32.0;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: size,
      height: size,
      child: TimerRing(
        progress: _timer.progress,
        phase: _timer.phase,
        timeText: _timer.timeDisplay,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: imgSize,
              height: imgSize,
              child: CapybaraFace(phase: _timer.phase),
            ),
            const SizedBox(height: 4),
            Text(
              _timer.phase == PomodoroPhase.idle
                  ? '25:00'
                  : _timer.phase == PomodoroPhase.completed
                  ? '00:00'
                  : _timer.timeDisplay,
              style: GoogleFonts.nunito(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: _buildActionContent(),
    );
  }

  Widget _buildActionContent() {
    switch (_timer.phase) {
      case PomodoroPhase.idle:
        return ActionButton(
          key: const ValueKey('start'),
          label: 'Start',
          onPressed: () => _timer.start(),
        );

      case PomodoroPhase.completed:
        return ActionButton(
          key: const ValueKey('again'),
          label: 'Start Again',
          onPressed: () {
            _timer.reset();
            _timer.start();
          },
        );

      case PomodoroPhase.focus:
      case PomodoroPhase.shortBreak:
      case PomodoroPhase.longBreak:
        return Column(
          key: ValueKey('running_${_timer.isRunning}'),
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              label: _timer.isRunning ? 'Pause' : 'Resume',
              onPressed: () {
                if (_timer.isRunning) {
                  _timer.pause();
                } else {
                  _timer.start();
                }
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  label: 'Skip',
                  onPressed: () => _timer.skip(),
                  isPrimary: false,
                ),
                const SizedBox(width: 16),
                ActionButton(
                  label: 'Reset',
                  onPressed: () => _timer.reset(),
                  isPrimary: false,
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ],
        );
    }
  }
}
