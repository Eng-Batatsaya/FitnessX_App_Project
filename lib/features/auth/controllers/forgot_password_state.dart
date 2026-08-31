import 'package:equatable/equatable.dart';

enum ForgotPasswordMethod { sms, email }

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordMethod selectedMethod;
  final String email;
  final String phoneNumber;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.selectedMethod = ForgotPasswordMethod.sms,
    this.email = '',
    this.phoneNumber = '',
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordMethod? selectedMethod,
    String? email,
    String? phoneNumber,
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedMethod, email, phoneNumber, status, errorMessage];
}
