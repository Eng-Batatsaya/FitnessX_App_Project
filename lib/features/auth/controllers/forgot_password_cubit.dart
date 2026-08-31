import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void selectMethod(ForgotPasswordMethod method) {
    emit(state.copyWith(
      selectedMethod: method,
      status: ForgotPasswordStatus.initial,
      errorMessage: null,
    ));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: ForgotPasswordStatus.initial));
  }

  void onPhoneChanged(String phone) {
    emit(state.copyWith(phoneNumber: phone, status: ForgotPasswordStatus.initial));
  }

  Future<void> sendResetRequest() async {
    final value = state.selectedMethod == ForgotPasswordMethod.email ? state.email : state.phoneNumber;
    
    if (value.isEmpty) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: "Please enter your ${state.selectedMethod == ForgotPasswordMethod.email ? 'email' : 'phone number'}",
      ));
      return;
    }

    if (state.selectedMethod == ForgotPasswordMethod.email) {
      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        emit(state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: "Please enter a valid email",
        ));
        return;
      }
    } else {
      if (value.length < 8) {
        emit(state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: "Please enter a valid phone number",
        ));
        return;
      }
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    // Mock success
    emit(state.copyWith(status: ForgotPasswordStatus.success));
  }
}
