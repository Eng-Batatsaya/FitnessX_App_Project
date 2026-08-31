import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final bool isPasswordVisible;

  const LoginState({this.isPasswordVisible = false});

  @override
  List<Object?> get props => [isPasswordVisible];
}

class LoginInitial extends LoginState {
  const LoginInitial({super.isPasswordVisible});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.isPasswordVisible});
}

class LoginSuccess extends LoginState {
  final bool isSocial;
  const LoginSuccess({this.isSocial = false, super.isPasswordVisible});

  @override
  List<Object?> get props => [isSocial, isPasswordVisible];
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required this.error, super.isPasswordVisible});

  @override
  List<Object?> get props => [error, isPasswordVisible];
}
