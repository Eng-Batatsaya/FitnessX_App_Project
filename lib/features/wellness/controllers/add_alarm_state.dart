// lib/features/wellness/controllers/add_alarm_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddAlarmState extends Equatable {
  const AddAlarmState({
    this.bedtime = const TimeOfDay(hour: 21, minute: 0),
    this.sleepDuration = const Duration(hours: 8, minutes: 30),
    this.repeatLabel = 'Once',
    this.vibrateEnabled = true,
    this.alarmSound = 'Classic',
    this.snoozeMinutes = 10,
    this.alarmLabel = '',
  });

  final TimeOfDay bedtime;
  final Duration sleepDuration;
  final String repeatLabel;
  final bool vibrateEnabled;
  final String alarmSound;
  final int snoozeMinutes;
  final String alarmLabel;

  AddAlarmState copyWith({
    TimeOfDay? bedtime,
    Duration? sleepDuration,
    String? repeatLabel,
    bool? vibrateEnabled,
    String? alarmSound,
    int? snoozeMinutes,
    String? alarmLabel,
  }) {
    return AddAlarmState(
      bedtime: bedtime ?? this.bedtime,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      repeatLabel: repeatLabel ?? this.repeatLabel,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      alarmSound: alarmSound ?? this.alarmSound,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      alarmLabel: alarmLabel ?? this.alarmLabel,
    );
  }

  @override
  List<Object?> get props => [
        bedtime,
        sleepDuration,
        repeatLabel,
        vibrateEnabled,
        alarmSound,
        snoozeMinutes,
        alarmLabel
      ];
}
