import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  final AuthService _authService = AuthService();

  void selectMethod(ForgotPasswordMethod method) {
    emit(
      state.copyWith(
        selectedMethod: method,
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void onEmailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void onPhoneChanged(String phone) {
    emit(
      state.copyWith(
        phoneNumber: phone,
        status: ForgotPasswordStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> sendResetRequest() async {
    // Email Reset
    if (state.selectedMethod == ForgotPasswordMethod.email) {
      final email = state.email.trim();

      if (email.isEmpty) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: "Please enter your email",
          ),
        );
        return;
      }

      if (!RegExp(
        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email)) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: "Please enter a valid email",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.loading,
          errorMessage: null,
        ),
      );

      try {
        await _authService.sendPasswordResetEmail(
          email: email,
        );

        emit(
          state.copyWith(
            status: ForgotPasswordStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.failure,
            errorMessage: _getFirebaseErrorMessage(e),
          ),
        );
      }

      return;
    }

    // Phone Reset
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: "Phone password reset is not available yet",
      ),
    );
  }

  String _getFirebaseErrorMessage(Object error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('invalid-email')) {
      return 'Please enter a valid email';
    }

    if (errorMessage.contains('user-not-found')) {
      return 'No user found with this email';
    }

    if (errorMessage.contains('network-request-failed')) {
      return 'Please check your internet connection';
    }

    if (errorMessage.contains('too-many-requests')) {
      return 'Too many requests. Please try again later';
    }

    return 'Something went wrong. Please try again';
  }
}