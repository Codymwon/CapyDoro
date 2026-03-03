import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_record.dart';

class StatsProvider extends ChangeNotifier {
  static const _key = 'session_history';
  final SharedPreferences _prefs;
  List<SessionRecord> _sessions = [];

  StatsProvider(this._prefs) {
    _load();
  }

  // ─── Getters ────────────────────────────────────────────

  List<SessionRecord> get recentSessions =>
      List.unmodifiable(_sessions.reversed);

  int get lifetimeSessions => _sessions.length;

  int get todaySessions {
    final now = DateTime.now();
    return _sessions
        .where(
          (s) =>
              s.completedAt.year == now.year &&
              s.completedAt.month == now.month &&
              s.completedAt.day == now.day,
        )
        .length;
  }

  int get todayMinutes {
    final now = DateTime.now();
    return _sessions
        .where(
          (s) =>
              s.completedAt.year == now.year &&
              s.completedAt.month == now.month &&
              s.completedAt.day == now.day,
        )
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  /// Consecutive days (ending today or yesterday) with at least one session.
  int get currentStreak {
    if (_sessions.isEmpty) return 0;

    // Build a set of unique dates (year-month-day) that have sessions
    final daysWithSessions = <DateTime>{};
    for (final s in _sessions) {
      daysWithSessions.add(
        DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day),
      );
    }

    final today = DateTime.now();
    var checkDay = DateTime(today.year, today.month, today.day);

    // If today has no session yet, start counting from yesterday
    if (!daysWithSessions.contains(checkDay)) {
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    int streak = 0;
    while (daysWithSessions.contains(checkDay)) {
      streak++;
      checkDay = checkDay.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Focus minutes per day for the last 7 days (index 0 = 6 days ago, 6 = today).
  List<DailyStats> get weeklyData {
    final today = DateTime.now();
    final result = <DailyStats>[];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: i));
      final minutes = _sessions
          .where(
            (s) =>
                s.completedAt.year == day.year &&
                s.completedAt.month == day.month &&
                s.completedAt.day == day.day,
          )
          .fold(0, (sum, s) => sum + s.durationMinutes);

      result.add(DailyStats(date: day, minutes: minutes));
    }
    return result;
  }

  // ─── Mutations ──────────────────────────────────────────

  Future<void> logSession(int durationMinutes) async {
    _sessions.add(
      SessionRecord(
        completedAt: DateTime.now(),
        durationMinutes: durationMinutes,
      ),
    );
    await _save();
    notifyListeners();
  }

  // ─── Persistence ────────────────────────────────────────

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw != null) {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      _sessions = list
          .map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _save() async {
    final json = jsonEncode(_sessions.map((s) => s.toJson()).toList());
    await _prefs.setString(_key, json);
  }
}

/// Helper class for the weekly chart data.
class DailyStats {
  final DateTime date;
  final int minutes;
  const DailyStats({required this.date, required this.minutes});
}
