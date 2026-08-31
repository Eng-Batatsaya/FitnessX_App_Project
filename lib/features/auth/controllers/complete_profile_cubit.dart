import 'package:flutter_bloc/flutter_bloc.dart';
import 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit() : super(const CompleteProfileState());

  void genderChanged(String value) {
    emit(state.copyWith(gender: value, status: CompleteProfileStatus.initial));
  }

  void dateOfBirthChanged(DateTime value) {
    emit(state.copyWith(dateOfBirth: value, status: CompleteProfileStatus.initial));
  }

  void weightChanged(String value) {
    emit(state.copyWith(weight: value, status: CompleteProfileStatus.initial));
  }

  void heightChanged(String value) {
    emit(state.copyWith(height: value, status: CompleteProfileStatus.initial));
  }

  Future<void> submit() async {
    if (state.gender == null ||
        state.dateOfBirth == null ||
        state.weight == null ||
        state.weight!.isEmpty ||
        state.height == null ||
        state.height!.isEmpty) {
      emit(state.copyWith(
        status: CompleteProfileStatus.failure,
        errorMessage: "Please fill in all fields",
      ));
      return;
    }

    // Basic validation for numeric values
    final weightVal = double.tryParse(state.weight!);
    final heightVal = double.tryParse(state.height!);

    if (weightVal == null || weightVal <= 0) {
      emit(state.copyWith(
        status: CompleteProfileStatus.failure,
        errorMessage: "Please enter a valid weight",
      ));
      return;
    }

    if (heightVal == null || heightVal <= 0) {
      emit(state.copyWith(
        status: CompleteProfileStatus.failure,
        errorMessage: "Please enter a valid height",
      ));
      return;
    }

    emit(state.copyWith(status: CompleteProfileStatus.loading));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Success
    emit(state.copyWith(status: CompleteProfileStatus.success));
  }
}
