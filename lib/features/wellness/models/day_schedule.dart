// lib/features/wellness/models/day_schedule.dart

/// One day's bedtime/alarm schedule. Immutable — Cubit states should never
/// be mutated in place, so every change goes through [copyWith] and
/// produces a new instance.
class DaySchedule {
  const DaySchedule({
    required this.bedtimeLabel,
    required this.bedtimeCountdown,
    required this.alarmLabel,
    required this.alarmCountdown,
    required this.sleepDurationLabel,
    required this.sleepPercent,
    this.bedtimeEnabled = true,
    this.alarmEnabled = true,
    this.alarmSound = 'Classic',
    this.snoozeMinutes = 10,
    this.alarmLabel2 = '',
  });

  final String bedtimeLabel;
  final String bedtimeCountdown;
  final String alarmLabel;
  final String alarmCountdown;
  final String sleepDurationLabel;
  final double sleepPercent;
  final bool bedtimeEnabled;
  final bool alarmEnabled;
  final String alarmSound;
  final int snoozeMinutes;
  final String alarmLabel2; // custom name, e.g. "Work Days"

  static const DaySchedule defaultSchedule = DaySchedule(
    bedtimeLabel: '09:00pm',
    bedtimeCountdown: 'in 6 hours 22 minutes',
    alarmLabel: '05:10am',
    alarmCountdown: 'in 14 hours 30 minutes',
    sleepDurationLabel: '8 hours 10 minutes',
    sleepPercent: 0.96,
  );

  DaySchedule copyWith({
    String? bedtimeLabel,
    String? bedtimeCountdown,
    String? alarmLabel,
    String? alarmCountdown,
    String? sleepDurationLabel,
    double? sleepPercent,
    bool? bedtimeEnabled,
    bool? alarmEnabled,
    String? alarmSound,
    int? snoozeMinutes,
    String? alarmLabel2,
  }) {
    return DaySchedule(
      bedtimeLabel: bedtimeLabel ?? this.bedtimeLabel,
      bedtimeCountdown: bedtimeCountdown ?? this.bedtimeCountdown,
      alarmLabel: alarmLabel ?? this.alarmLabel,
      alarmCountdown: alarmCountdown ?? this.alarmCountdown,
      sleepDurationLabel: sleepDurationLabel ?? this.sleepDurationLabel,
      sleepPercent: sleepPercent ?? this.sleepPercent,
      bedtimeEnabled: bedtimeEnabled ?? this.bedtimeEnabled,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      alarmSound: alarmSound ?? this.alarmSound,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      alarmLabel2: alarmLabel2 ?? this.alarmLabel2,
    );
  }
}
