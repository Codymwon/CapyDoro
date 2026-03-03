class SessionRecord {
  final DateTime completedAt;
  final int durationMinutes;

  SessionRecord({required this.completedAt, required this.durationMinutes});

  Map<String, dynamic> toJson() => {
    'completedAt': completedAt.toIso8601String(),
    'durationMinutes': durationMinutes,
  };

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      completedAt: DateTime.parse(json['completedAt'] as String),
      durationMinutes: json['durationMinutes'] as int,
    );
  }
}
