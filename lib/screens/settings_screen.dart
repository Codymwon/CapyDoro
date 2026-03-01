import 'package:flutter/material.dart';
import '../main.dart' show settingsProvider, themeProvider;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListenableBuilder(
        listenable: settingsProvider,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _buildSectionHeader(context, 'DURATION (MINUTES)'),
              _buildSlider(
                context,
                title: 'Focus Session',
                value: settingsProvider.focusDuration.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                onChanged: (val) =>
                    settingsProvider.setFocusDuration(val.toInt()),
              ),
              _buildSlider(
                context,
                title: 'Short Break',
                value: settingsProvider.shortBreakDuration.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (val) =>
                    settingsProvider.setShortBreakDuration(val.toInt()),
              ),
              _buildSlider(
                context,
                title: 'Long Break',
                value: settingsProvider.longBreakDuration.toDouble(),
                min: 5,
                max: 60,
                divisions: 11,
                onChanged: (val) =>
                    settingsProvider.setLongBreakDuration(val.toInt()),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader(context, 'SESSION CYCLES'),
              _buildDropdown(
                context,
                title: 'Long Break Interval',
                value: settingsProvider.longBreakInterval,
                items: [2, 3, 4, 5, 6, 7, 8],
                onChanged: (val) {
                  if (val != null) settingsProvider.setLongBreakInterval(val);
                },
              ),

              const SizedBox(height: 24),
              _buildSectionHeader(context, 'AUTOMATION'),
              _buildSwitch(
                context,
                title: 'Auto-start Breaks',
                subtitle: 'Automatically start breaks when focus ends',
                value: settingsProvider.autoStartBreaks,
                onChanged: settingsProvider.setAutoStartBreaks,
              ),
              _buildSwitch(
                context,
                title: 'Auto-start Focus',
                subtitle: 'Automatically start focus when break ends',
                value: settingsProvider.autoStartFocus,
                onChanged: settingsProvider.setAutoStartFocus,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader(context, 'NOTIFICATIONS & ALERTS'),
              _buildSwitch(
                context,
                title: 'Sound Alerts',
                subtitle: 'Play a chime when a timer finishes',
                value: settingsProvider.soundEnabled,
                onChanged: settingsProvider.setSoundEnabled,
              ),
              _buildSwitch(
                context,
                title: 'Vibrate',
                subtitle: 'Vibrate the phone when a timer finishes',
                value: settingsProvider.vibrateEnabled,
                onChanged: settingsProvider.setVibrateEnabled,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader(context, 'APPEARANCE'),
              _buildThemeSelector(context),
              const SizedBox(height: 48), // Bottom padding
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${value.toInt()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              thumbColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String title,
    required int value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: value,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(16),
            items: items.map((int item) {
              return DropdownMenuItem<int>(
                value: item,
                child: Text(
                  '$item sessions',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
        ),
      ),
      value: value,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: onChanged,
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment<String>(
          value: 'system',
          label: Text('System'),
          icon: Icon(Icons.settings_system_daydream_rounded),
        ),
        ButtonSegment<String>(
          value: 'light',
          label: Text('Light'),
          icon: Icon(Icons.light_mode_rounded),
        ),
        ButtonSegment<String>(
          value: 'dark',
          label: Text('Dark'),
          icon: Icon(Icons.dark_mode_rounded),
        ),
      ],
      selected: {settingsProvider.themeMode},
      onSelectionChanged: (Set<String> newSelection) {
        settingsProvider.setThemeMode(newSelection.first);
        // Force the themeProvider to re-evaluate the override and notify the MaterialApp
        themeProvider.updateTheme();
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedBackgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
