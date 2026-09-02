import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    emit(
      LoginInitial(
        isPasswordVisible: !state.isPasswordVisible,
      ),
    );
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(
        LoginFailure(
          error: "Please fill in all fields",
          isPasswordVisible: state.isPasswordVisible,
        ),
      );
      return;
    }

    emit(
      LoginLoading(
        isPasswordVisible: state.isPasswordVisible,
      ),
    );

    try {
      await _authService.login(
        email: email.trim(),
        password: password,
      );

      emit(
        LoginSuccess(
          isPasswordVisible: state.isPasswordVisible,
        ),
      );
    } catch (e) {
      emit(
        LoginFailure(
          error: _getFirebaseErrorMessage(e),
          isPasswordVisible: state.isPasswordVisible,
        ),
      );
    }
  }

  String _getFirebaseErrorMessage(Object error) {
    final errorMessage = error.toString();

    if (errorMessage.contains('user-not-found')) {
      return 'No user found with this email';
    }

    if (errorMessage.contains('wrong-password')) {
      return 'Incorrect password';
    }

    if (errorMessage.contains('invalid-email')) {
      return 'Invalid email address';
    }

    if (errorMessage.contains('invalid-credential')) {
      return 'Invalid email or password';
    }

    if (errorMessage.contains('network-request-failed')) {
      return 'Please check your internet connection';
    }

    return 'Something went wrong. Please try again';
  }

  void socialLogin(String provider) async {
    emit(
      LoginLoading(
        isPasswordVisible: state.isPasswordVisible,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      LoginSuccess(
        isSocial: true,
        isPasswordVisible: state.isPasswordVisible,
      ),
    );
  }
}