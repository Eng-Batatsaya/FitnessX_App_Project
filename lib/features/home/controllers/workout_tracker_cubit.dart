import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_tracker_state.dart';

class WorkoutTrackerCubit extends Cubit<WorkoutTrackerState> {
  WorkoutTrackerCubit() : super(const WorkoutTrackerState()) {
    _initData();
  }

  void _initData() {
    final upcoming = [
      const UpcomingWorkout(
        title: "Fullbody Workout",
        time: "Today, 03:00pm",
        isOn: true,
        color: Color(0xFF92A3FD),
      ),
      const UpcomingWorkout(
        title: "Upperbody Workout",
        time: "June 05, 02:00pm",
        isOn: false,
        color: Color(0xFFC58BF2),
      ),
      const UpcomingWorkout(
        title: "Ab Workout",
        time: "June 07, 10:00am",
        isOn: true,
        color: Color(0xFF92A3FD),
      ),
      const UpcomingWorkout(
        title: "Lowerbody Workout",
        time: "June 10, 04:00pm",
        isOn: false,
        color: Color(0xFFC58BF2),
      ),
    ];

    final details = {
      0: const DayDetail(date: "23 May", percent: 60, workout: "Fullbody Workout"),
      1: const DayDetail(date: "24 May", percent: 45, workout: "Lowerbody Workout"),
      2: const DayDetail(date: "25 May", percent: 80, workout: "Ab Workout"),
      3: const DayDetail(date: "26 May", percent: 30, workout: "Rest Day"),
      4: const DayDetail(date: "27 May", percent: 55, workout: "Leg Workout"),
      5: const DayDetail(date: "28 May", percent: 90, workout: "Upperbody Workout"),
      6: const DayDetail(date: "29 May", percent: 70, workout: "Cardio Workout"),
    };

    emit(state.copyWith(upcomingWorkouts: upcoming, dayDetails: details));
  }

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
  }

  void toggleShowAll() {
    emit(state.copyWith(showAllUpcoming: !state.showAllUpcoming));
  }

  void toggleWorkout(int index, bool isOn) {
    final updated = List<UpcomingWorkout>.from(state.upcomingWorkouts);
    updated[index] = updated[index].copyWith(isOn: isOn);
    emit(state.copyWith(upcomingWorkouts: updated));
  }

  void resetWeek() {
    final updatedDetails = state.dayDetails.map((key, value) {
      return MapEntry(key, value.copyWith(percent: 0, workout: "Not started"));
    });
    emit(state.copyWith(dayDetails: updatedDetails));
  }

  void updateGoal(int targetPercent) {
    // Logic for updating goals could be added here
  }
}
