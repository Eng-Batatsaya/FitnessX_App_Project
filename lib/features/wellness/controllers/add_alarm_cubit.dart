// lib/features/wellness/controllers/add_alarm_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_alarm_state.dart';

class AddAlarmCubit extends Cubit<AddAlarmState> {
  AddAlarmCubit() : super(const AddAlarmState());

  void setBedtime(TimeOfDay time) => emit(state.copyWith(bedtime: time));
  void setSleepDuration(Duration duration) =>
      emit(state.copyWith(sleepDuration: duration));
  void setRepeat(String label) => emit(state.copyWith(repeatLabel: label));
  void toggleVibrate(bool value) => emit(state.copyWith(vibrateEnabled: value));
  void setAlarmSound(String sound) => emit(state.copyWith(alarmSound: sound));
  void setSnooze(int minutes) => emit(state.copyWith(snoozeMinutes: minutes));
  void setAlarmLabel(String label) => emit(state.copyWith(alarmLabel: label));

  // --- Formatting -------------------------------------------------------

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _formatTimeCompact(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute$period';
  }

  String formatDuration(Duration d) =>
      '${d.inHours}hours ${d.inMinutes % 60}minutes';

  String _countdownFrom(TimeOfDay target) {
    final now = DateTime.now();
    var targetDt =
        DateTime(now.year, now.month, now.day, target.hour, target.minute);
    if (!targetDt.isAfter(now)) {
      targetDt = targetDt.add(const Duration(days: 1));
    }
    final diff = targetDt.difference(now);
    return 'in ${diff.inHours} hours ${diff.inMinutes % 60} minutes';
  }

  TimeOfDay _addDuration(TimeOfDay t, Duration d) {
    final total = (t.hour * 60 + t.minute + d.inMinutes) % (24 * 60);
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  /// Builds the result map returned to SleepScheduleScreen when "Add" is
  /// pressed — moved here (out of the widget) so the screen stays dumb.
  Map<String, dynamic> buildResult() {
    final alarmTime = _addDuration(state.bedtime, state.sleepDuration);
    const idealMinutes = 8 * 60 + 30;
    final percent =
        (state.sleepDuration.inMinutes / idealMinutes).clamp(0.0, 1.0);

    return {
      'bedtimeLabel': _formatTimeCompact(state.bedtime),
      'bedtimeCountdown': _countdownFrom(state.bedtime),
      'alarmLabel': _formatTimeCompact(alarmTime),
      'alarmCountdown': _countdownFrom(alarmTime),
      'sleepDurationLabel': formatDuration(state.sleepDuration)
          .replaceAll('hours', ' hours')
          .replaceAll('minutes', ' minutes'),
      'sleepPercent': percent,
      'repeatLabel': state.repeatLabel,
      'vibrateEnabled': state.vibrateEnabled,
      'alarmSound': state.alarmSound,
      'snoozeMinutes': state.snoozeMinutes,
      'alarmLabel2': state.alarmLabel,
    };
  }
}
