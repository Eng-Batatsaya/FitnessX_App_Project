import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterInitial());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleTerms(bool value) {
    emit(state.copyWith(isTermsAccepted: value));
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required bool termsAccepted,
  }) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      emit(RegisterFailure(
        error: "Please fill in all fields",
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ));
      return;
    }

    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emit(RegisterFailure(
        error: "Please enter a valid email",
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ));
      return;
    }

    if (password.length < 6) {
      emit(RegisterFailure(
        error: "Password must be at least 6 characters",
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ));
      return;
    }

    if (!termsAccepted) {
      emit(RegisterFailure(
        error: "Please accept the Terms & Conditions",
        isPasswordVisible: state.isPasswordVisible,
        isTermsAccepted: state.isTermsAccepted,
      ));
      return;
    }

    emit(RegisterLoading(
      isPasswordVisible: state.isPasswordVisible,
      isTermsAccepted: state.isTermsAccepted,
    ));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock success
    emit(RegisterSuccess(
      isPasswordVisible: state.isPasswordVisible,
      isTermsAccepted: state.isTermsAccepted,
    ));
  }

  void socialRegister(String provider) async {
    emit(RegisterLoading(
      isPasswordVisible: state.isPasswordVisible,
      isTermsAccepted: state.isTermsAccepted,
    ));
    await Future.delayed(const Duration(seconds: 1));
    emit(RegisterSuccess(
      isSocial: true,
      isPasswordVisible: state.isPasswordVisible,
      isTermsAccepted: state.isTermsAccepted,
    ));
  }
}
