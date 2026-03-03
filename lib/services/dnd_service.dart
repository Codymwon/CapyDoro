import 'dart:io';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:sound_mode/permission_handler.dart';

class DndService {
  DndService._();

  /// Returns true if the device is Android and has granted DND policy access.
  /// Always returns false on iOS (no programmatic DND access).
  static Future<bool> isPermissionGranted() async {
    if (!Platform.isAndroid) return false;

    bool? isGranted = await PermissionHandler.permissionsGranted;
    return isGranted ?? false;
  }

  /// Opens the Android system settings page for the user to grant DND access.
  /// Does nothing on iOS.
  static Future<void> openPermissionSettings() async {
    if (!Platform.isAndroid) return;
    await PermissionHandler.openDoNotDisturbSetting();
  }

  /// Turns DND on (InterruptionFilterNone).
  /// Safe to call on iOS (does nothing).
  static Future<void> setDndOn() async {
    if (!Platform.isAndroid) return;

    if (await isPermissionGranted()) {
      await SoundMode.setSoundMode(RingerModeStatus.silent);
    }
  }

  /// Turns DND off (InterruptionFilterAll).
  /// Safe to call on iOS (does nothing).
  static Future<void> setDndOff() async {
    if (!Platform.isAndroid) return;

    if (await isPermissionGranted()) {
      await SoundMode.setSoundMode(RingerModeStatus.normal);
    }
  }
}
