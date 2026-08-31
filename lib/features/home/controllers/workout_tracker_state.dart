import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UpcomingWorkout extends Equatable {
  final String title;
  final String time;
  final bool isOn;
  final Color color;

  const UpcomingWorkout({
    required this.title,
    required this.time,
    required this.isOn,
    required this.color,
  });

  UpcomingWorkout copyWith({bool? isOn}) {
    return UpcomingWorkout(
      title: title,
      time: time,
      isOn: isOn ?? this.isOn,
      color: color,
    );
  }

  @override
  List<Object?> get props => [title, time, isOn, color];
}

class DayDetail extends Equatable {
  final String date;
  final int percent;
  final String workout;

  const DayDetail({
    required this.date,
    required this.percent,
    required this.workout,
  });

  DayDetail copyWith({int? percent, String? workout}) {
    return DayDetail(
      date: date,
      percent: percent ?? this.percent,
      workout: workout ?? this.workout,
    );
  }

  @override
  List<Object?> get props => [date, percent, workout];
}

class WorkoutTrackerState extends Equatable {
  final int selectedDayIndex;
  final bool showAllUpcoming;
  final List<UpcomingWorkout> upcomingWorkouts;
  final Map<int, DayDetail> dayDetails;

  const WorkoutTrackerState({
    this.selectedDayIndex = 5,
    this.showAllUpcoming = false,
    this.upcomingWorkouts = const [],
    this.dayDetails = const {},
  });

  WorkoutTrackerState copyWith({
    int? selectedDayIndex,
    bool? showAllUpcoming,
    List<UpcomingWorkout>? upcomingWorkouts,
    Map<int, DayDetail>? dayDetails,
  }) {
    return WorkoutTrackerState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      showAllUpcoming: showAllUpcoming ?? this.showAllUpcoming,
      upcomingWorkouts: upcomingWorkouts ?? this.upcomingWorkouts,
      dayDetails: dayDetails ?? this.dayDetails,
    );
  }

  @override
  List<Object?> get props => [selectedDayIndex, showAllUpcoming, upcomingWorkouts, dayDetails];
}
