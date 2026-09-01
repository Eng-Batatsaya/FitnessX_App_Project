import 'package:fitness_app/features/auth/controllers/reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());

  void onNewPasswordChanged(String value) {
    emit(state.copyWith(
      newPassword: value,
      status: ResetPasswordStatus.initial,
    ));
  }

  void onConfirmPasswordChanged(String value) {
    emit(state.copyWith(
      confirmPassword: value,
      status: ResetPasswordStatus.initial,
    ));
  }

  void toggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  Future<void> resetPassword() async {
    if (state.newPassword.isEmpty) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: 'New password cannot be empty',
      ));
      return;
    }

    if (state.confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: 'Confirm password cannot be empty',
      ));
      return;
    }

    if (state.newPassword != state.confirmPassword) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: 'Passwords do not match',
      ));
      return;
    }

    emit(state.copyWith(status: ResetPasswordStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      emit(state.copyWith(status: ResetPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
