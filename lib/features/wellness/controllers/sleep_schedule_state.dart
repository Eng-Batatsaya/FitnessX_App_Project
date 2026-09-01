// lib/features/wellness/controllers/sleep_schedule_state.dart
import 'package:equatable/equatable.dart';
import '../models/day_schedule.dart';

class SleepScheduleState extends Equatable {
  const SleepScheduleState({
    required this.dates,
    required this.schedules,
    required this.selectedIndex,
    this.sleepSound = 'Rain',
    this.notificationsEnabled = true,
  });

  final List<DateTime> dates;
  final Map<int, DaySchedule> schedules;
  final int selectedIndex;
  final String sleepSound;
  final bool notificationsEnabled;

  DaySchedule get current => schedules[selectedIndex]!;

  static List<DateTime> buildDates() {
    final today = DateTime.now();
    return List.generate(
      14,
      (i) => DateTime(today.year, today.month, today.day - 3 + i),
    );
  }

  static Map<int, DaySchedule> defaultSchedules(List<DateTime> dates) {
    return {
      for (int i = 0; i < dates.length; i++) i: DaySchedule.defaultSchedule,
    };
  }

  factory SleepScheduleState.initial() {
    final dates = buildDates();
    return SleepScheduleState(
      dates: dates,
      schedules: defaultSchedules(dates),
      selectedIndex: 3, // "today"
    );
  }

  SleepScheduleState copyWith({
    List<DateTime>? dates,
    Map<int, DaySchedule>? schedules,
    int? selectedIndex,
    String? sleepSound,
    bool? notificationsEnabled,
  }) {
    return SleepScheduleState(
      dates: dates ?? this.dates,
      schedules: schedules ?? this.schedules,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      sleepSound: sleepSound ?? this.sleepSound,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [dates, schedules, selectedIndex, sleepSound, notificationsEnabled];
}
