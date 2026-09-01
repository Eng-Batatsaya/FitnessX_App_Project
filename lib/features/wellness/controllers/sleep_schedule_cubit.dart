// lib/features/wellness/controllers/sleep_schedule_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/day_schedule.dart';
import 'sleep_schedule_state.dart';

class SleepScheduleCubit extends Cubit<SleepScheduleState> {
  SleepScheduleCubit() : super(SleepScheduleState.initial());

  void selectDay(int index) => emit(state.copyWith(selectedIndex: index));

  void setSleepSound(String sound) => emit(state.copyWith(sleepSound: sound));

  void toggleNotifications() =>
      emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));

  void resetSchedule() {
    emit(state.copyWith(
        schedules: SleepScheduleState.defaultSchedules(state.dates)));
  }

  void toggleBedtime(bool value) =>
      _updateCurrent((d) => d.copyWith(bedtimeEnabled: value));

  void toggleAlarm(bool value) =>
      _updateCurrent((d) => d.copyWith(alarmEnabled: value));

  void deleteEntry(String entryKey) {
    if (entryKey == 'bedtime') {
      _updateCurrent((d) => d.copyWith(bedtimeEnabled: false));
    } else {
      _updateCurrent((d) => d.copyWith(alarmEnabled: false));
    }
  }

  /// Applies the result returned from AddAlarmScreen to every day matching
  /// the chosen "Repeat" option, plus the day currently selected.
  void applyAlarmResult(Map<String, dynamic> result) {
    final repeatLabel = result['repeatLabel'] as String? ?? 'Once';
    final targetIndexes = _indexesForRepeat(repeatLabel).toSet()
      ..add(state.selectedIndex);

    final updated = Map<int, DaySchedule>.from(state.schedules);
    for (final i in targetIndexes) {
      final current = updated[i];
      if (current == null) continue;
      updated[i] = current.copyWith(
        bedtimeLabel: result['bedtimeLabel'],
        bedtimeCountdown: result['bedtimeCountdown'],
        alarmLabel: result['alarmLabel'],
        alarmCountdown: result['alarmCountdown'],
        sleepDurationLabel: result['sleepDurationLabel'],
        sleepPercent: result['sleepPercent'],
        alarmSound: result['alarmSound'] ?? 'Classic',
        snoozeMinutes: result['snoozeMinutes'] ?? 10,
        alarmLabel2: result['alarmLabel2'] ?? '',
        bedtimeEnabled: true,
        alarmEnabled: true,
      );
    }
    emit(state.copyWith(schedules: updated));
  }

  void _updateCurrent(DaySchedule Function(DaySchedule) update) {
    final updated = Map<int, DaySchedule>.from(state.schedules);
    updated[state.selectedIndex] = update(updated[state.selectedIndex]!);
    emit(state.copyWith(schedules: updated));
  }

  List<int> _indexesForRepeat(String repeatLabel) {
    final dates = state.dates;
    switch (repeatLabel) {
      case 'Every day':
        return List.generate(dates.length, (i) => i);
      case 'Mon to Fri':
        return [
          for (int i = 0; i < dates.length; i++)
            if (dates[i].weekday >= DateTime.monday &&
                dates[i].weekday <= DateTime.friday)
              i,
        ];
      case 'Weekends':
        return [
          for (int i = 0; i < dates.length; i++)
            if (dates[i].weekday == DateTime.saturday ||
                dates[i].weekday == DateTime.sunday)
              i,
        ];
      case 'Once':
      default:
        return [state.selectedIndex];
    }
  }
}
