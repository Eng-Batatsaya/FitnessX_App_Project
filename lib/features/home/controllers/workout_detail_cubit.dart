import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_detail_state.dart';

class WorkoutDetailCubit extends Cubit<WorkoutDetailState> {
  WorkoutDetailCubit()
      : super(WorkoutDetailState(
          selectedDateTime: DateTime.now().add(const Duration(days: 1)),
        ));

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void updateDateTime(DateTime dateTime) {
    emit(state.copyWith(selectedDateTime: dateTime));
  }

  void updateDifficulty(String difficulty) {
    emit(state.copyWith(selectedDifficulty: difficulty));
  }

  void toggleNeed(String need) {
    final updated = Set<String>.from(state.selectedNeeds);
    if (updated.contains(need)) {
      updated.remove(need);
    } else {
      updated.add(need);
    }
    emit(state.copyWith(selectedNeeds: updated));
  }

  void toggleExercise(String title) {
    final updated = Set<String>.from(state.completedExercises);
    if (updated.contains(title)) {
      updated.remove(title);
    } else {
      updated.add(title);
    }
    emit(state.copyWith(completedExercises: updated));
  }
}
