import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  void togglePasswordVisibility() {
    emit(LoginInitial(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure(
        error: "Please fill in all fields",
        isPasswordVisible: state.isPasswordVisible,
      ));
      return;
    }

    emit(LoginLoading(isPasswordVisible: state.isPasswordVisible));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock success check
    if (email == "test@test.com" && password == "password123") {
      emit(LoginSuccess(isPasswordVisible: state.isPasswordVisible));
    } else {
      emit(LoginFailure(
        error: "Invalid email or password",
        isPasswordVisible: state.isPasswordVisible,
      ));
    }
  }

  void socialLogin(String provider) async {
    emit(LoginLoading(isPasswordVisible: state.isPasswordVisible));
    await Future.delayed(const Duration(seconds: 1));
    emit(LoginSuccess(isSocial: true, isPasswordVisible: state.isPasswordVisible));
  }
}
