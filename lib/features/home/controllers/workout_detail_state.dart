import 'package:equatable/equatable.dart';

class WorkoutDetailState extends Equatable {
  final bool isFavorite;
  final DateTime selectedDateTime;
  final String selectedDifficulty;
  final Set<String> selectedNeeds;
  final Set<String> completedExercises;

  const WorkoutDetailState({
    this.isFavorite = false,
    required this.selectedDateTime,
    this.selectedDifficulty = "Beginner",
    this.selectedNeeds = const {},
    this.completedExercises = const {},
  });

  WorkoutDetailState copyWith({
    bool? isFavorite,
    DateTime? selectedDateTime,
    String? selectedDifficulty,
    Set<String>? selectedNeeds,
    Set<String>? completedExercises,
  }) {
    return WorkoutDetailState(
      isFavorite: isFavorite ?? this.isFavorite,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedNeeds: selectedNeeds ?? this.selectedNeeds,
      completedExercises: completedExercises ?? this.completedExercises,
    );
  }

  @override
  List<Object?> get props => [
        isFavorite,
        selectedDateTime,
        selectedDifficulty,
        selectedNeeds,
        completedExercises,
      ];
}
