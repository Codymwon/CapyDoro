import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart' show statsProvider, settingsProvider;
import '../theme/app_colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListenableBuilder(
        listenable: statsProvider,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _buildSummaryCards(context),
              const SizedBox(height: 28),
              _buildSectionHeader(context, 'THIS WEEK'),
              const SizedBox(height: 8),
              _buildWeeklyChart(context),
              const SizedBox(height: 28),
              _buildSectionHeader(context, 'RECENT SESSIONS'),
              const SizedBox(height: 8),
              _buildSessionHistory(context),
              const SizedBox(height: 48),
            ],
          );
        },
      ),
    );
  }

  // ─── Summary Cards ────────────────────────────────────────

  Widget _buildSummaryCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildCard(
          context,
          icon: Icons.today_rounded,
          label: "Today's Sessions",
          value: '${statsProvider.todaySessions}',
        ),
        _buildCard(
          context,
          icon: Icons.timer_rounded,
          label: "Today's Focus",
          value: '${statsProvider.todayMinutes} min',
        ),
        _buildCard(
          context,
          icon: Icons.local_fire_department_rounded,
          label: 'Current Streak',
          value:
              '${statsProvider.currentStreak} day${statsProvider.currentStreak == 1 ? '' : 's'}',
          valueColor: AppColors.danger,
        ),
        _buildCard(
          context,
          icon: Icons.emoji_events_rounded,
          label: 'Lifetime',
          value: '${settingsProvider.totalLifetimeSessions} sessions',
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2C2824) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── Weekly Chart ─────────────────────────────────────────

  Widget _buildWeeklyChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2C2824) : Colors.white;
    final weekly = statsProvider.weeklyData;
    final maxMinutes = weekly.fold<int>(
      0,
      (m, d) => d.minutes > m ? d.minutes : m,
    );
    final maxY = maxMinutes == 0 ? 60.0 : (maxMinutes * 1.3).ceilToDouble();

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()} min',
                  GoogleFonts.nunito(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.5),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= weekly.length) {
                    return const SizedBox.shrink();
                  }
                  final weekday = weekly[idx].date.weekday; // 1=Mon ... 7=Sun
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dayLabels[weekday - 1],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(weekly.length, (i) {
            final isToday = i == weekly.length - 1;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: weekly[i].minutes.toDouble(),
                  color: isToday
                      ? AppColors.focus
                      : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }),
        ),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }

  // ─── Session History ──────────────────────────────────────

  Widget _buildSessionHistory(BuildContext context) {
    final sessions = statsProvider.recentSessions;

    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No sessions yet.\nComplete a focus session to see your history!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    // Group by date
    final grouped = <String, List<dynamic>>{};
    for (final s in sessions) {
      final dayKey = _formatDate(s.completedAt);
      grouped.putIfAbsent(dayKey, () => []).add(s);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2C2824) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in grouped.entries) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              ...entry.value.map(
                (s) => ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.focus.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: AppColors.focus,
                    ),
                  ),
                  title: Text(
                    '${s.durationMinutes} min focus session',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    _formatTime(s.completedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
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

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}
