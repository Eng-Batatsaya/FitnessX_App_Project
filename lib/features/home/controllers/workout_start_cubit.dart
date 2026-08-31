import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'workout_start_state.dart';

class WorkoutStartCubit extends Cubit<WorkoutStartState> {
  WorkoutStartCubit() : super(const WorkoutStartState());

  void updateRepetitions(int reps) {
    emit(state.copyWith(repetitions: reps));
  }

  void toggleExpansion() {
    emit(state.copyWith(isExpanded: !state.isExpanded));
  }

  Future<void> saveWorkout() async {
    emit(state.copyWith(isSaving: true));
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isSaving: false));
  }
}
