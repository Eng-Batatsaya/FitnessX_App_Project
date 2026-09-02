import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterInitial());

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
      ),
    );
  }

  void toggleTerms(bool value) {
    emit(
      state.copyWith(
        isTermsAccepted: value,
      ),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required bool termsAccepted,
  }) async {
    // Check empty fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      emit(
        RegisterFailure(
          error: "Please fill in all fields",
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
      return;
    }

    // Check email format
    if (!RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email)) {
      emit(
        RegisterFailure(
          error: "Please enter a valid email",
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
      return;
    }

    // Check password length
    if (password.length < 6) {
      emit(
        RegisterFailure(
          error: "Password must be at least 6 characters",
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
      return;
    }

    // Check terms
    if (!termsAccepted) {
      emit(
        RegisterFailure(
          error: "Please accept the Terms & Conditions",
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
      return;
    }

    // Loading
    emit(
      RegisterLoading(
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ),
    );

    try {
      // Firebase Sign Up
      await _authService.signUp(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        password: password,
      );

      // Success
      emit(
        RegisterSuccess(
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
    } catch (e) {
      emit(
        RegisterFailure(
          error: _getFirebaseErrorMessage(e),
          isPasswordVisible: state.isPasswordVisible,
          isTermsAccepted: state.isTermsAccepted,
        ),
      );
    }
  }

  String _getFirebaseErrorMessage(Object error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('email-already-in-use')) {
      return 'This email is already registered';
    }

    if (errorMessage.contains('invalid-email')) {
      return 'Please enter a valid email';
    }

    if (errorMessage.contains('weak-password')) {
      return 'Password is too weak';
    }

    if (errorMessage.contains('network-request-failed')) {
      return 'Please check your internet connection';
    }

    return 'Something went wrong. Please try again';
  }

  void socialRegister(String provider) {
    emit(
      RegisterFailure(
        error: '$provider registration is not available yet',
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ),
    );
  }
}

