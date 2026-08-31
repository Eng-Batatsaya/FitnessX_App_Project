import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  final String newPassword;
  final String confirmPassword;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    ResetPasswordStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        newPassword,
        confirmPassword,
        isNewPasswordVisible,
        isConfirmPasswordVisible,
        status,
        errorMessage,
      ];
}
