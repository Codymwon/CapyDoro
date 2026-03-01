import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// The callback function must be top-level or static.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler());
}

class TimerTaskHandler extends TaskHandler {
  DateTime? _endTime;
  String _phaseLabel = '';

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // When the service starts, it receives data via `onReceiveData`
  }

  @override
  void onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('endTimeMillis')) {
        _endTime = DateTime.fromMillisecondsSinceEpoch(
          data['endTimeMillis'] as int,
        );
      }
      if (data.containsKey('phaseLabel')) {
        _phaseLabel = data['phaseLabel'] as String;
      }
      _updateNotification();
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _updateNotification();
  }

  void _updateNotification() {
    if (_endTime == null) return;

    final now = DateTime.now();
    final remaining = _endTime!.difference(now);

    if (remaining.inSeconds <= 0) {
      // Phase complete! Add a little buffer so UI can handle it
      FlutterForegroundTask.updateService(
        notificationTitle: 'Phase Complete! 🎉',
        notificationText: 'Tap to return to CapyDoro.',
      );

      FlutterForegroundTask.sendDataToMain({'action': 'phase_complete'});
      return;
    }

    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    FlutterForegroundTask.updateService(
      notificationTitle: _phaseLabel,
      notificationText: '$minutes:$seconds remaining',
    );

    // Also send current remaining back to main just in case
    FlutterForegroundTask.sendDataToMain({
      'action': 'tick',
      'remainingSeconds': remaining.inSeconds,
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    // Bring app to foreground
    FlutterForegroundTask.launchApp();
  }

  @override
  void onNotificationDismissed() {}
}
