part of 'workout_start_cubit.dart';

class WorkoutStartState extends Equatable {
  final int repetitions;
  final bool isExpanded;
  final bool isSaving;

  const WorkoutStartState({
    this.repetitions = 30,
    this.isExpanded = false,
    this.isSaving = false,
  });

  WorkoutStartState copyWith({
    int? repetitions,
    bool? isExpanded,
    bool? isSaving,
  }) {
    return WorkoutStartState(
      repetitions: repetitions ?? this.repetitions,
      isExpanded: isExpanded ?? this.isExpanded,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object> get props => [repetitions, isExpanded, isSaving];
}
