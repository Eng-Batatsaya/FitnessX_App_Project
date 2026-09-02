import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({
    required this.oobCode,
  }) : super(const ResetPasswordState());

  final String oobCode;

  void onNewPasswordChanged(String value) {
    emit(
      state.copyWith(
        newPassword: value,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  void onConfirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  void toggleNewPasswordVisibility() {
    emit(
      state.copyWith(
        isNewPasswordVisible: !state.isNewPasswordVisible,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordVisible:
        !state.isConfirmPasswordVisible,
      ),
    );
  }

  Future<void> resetPassword() async {
    if (state.newPassword.isEmpty) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: 'New password cannot be empty',
        ),
      );
      return;
    }

    if (state.confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Confirm password cannot be empty',
        ),
      );
      return;
    }

    if (state.newPassword.length < 6) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage:
          'Password must be at least 6 characters',
        ),
      );
      return;
    }

    if (state.newPassword != state.confirmPassword) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Passwords do not match',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ResetPasswordStatus.loading,
      ),
    );

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: state.newPassword,
      );

      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'expired-action-code':
          message =
          'This password reset link has expired. Please request a new one.';
          break;

        case 'invalid-action-code':
          message =
          'This password reset link is invalid or has already been used.';
          break;

        case 'weak-password':
          message =
          'Password is too weak. Please choose a stronger password.';
          break;

        case 'user-disabled':
          message =
          'This account has been disabled.';
          break;

        default:
          message =
          'Something went wrong. Please try again.';
      }

      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}