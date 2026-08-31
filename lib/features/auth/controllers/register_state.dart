import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  final bool isPasswordVisible;
  final bool isTermsAccepted;

  const RegisterState({
    this.isPasswordVisible = false,
    this.isTermsAccepted = false,
  });

  @override
  List<Object?> get props => [isPasswordVisible, isTermsAccepted];

  RegisterState copyWith({
    bool? isPasswordVisible,
    bool? isTermsAccepted,
  });
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({
    super.isPasswordVisible,
    super.isTermsAccepted,
  });

  @override
  RegisterInitial copyWith({
    bool? isPasswordVisible,
    bool? isTermsAccepted,
  }) {
    return RegisterInitial(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({
    super.isPasswordVisible,
    super.isTermsAccepted,
  });

  @override
  RegisterLoading copyWith({
    bool? isPasswordVisible,
    bool? isTermsAccepted,
  }) {
    return RegisterLoading(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}

class RegisterSuccess extends RegisterState {
  final bool isSocial;
  const RegisterSuccess({
    this.isSocial = false,
    super.isPasswordVisible,
    super.isTermsAccepted,
  });

  @override
  List<Object?> get props => [isSocial, isPasswordVisible, isTermsAccepted];

  @override
  RegisterSuccess copyWith({
    bool? isPasswordVisible,
    bool? isTermsAccepted,
    bool? isSocial,
  }) {
    return RegisterSuccess(
      isSocial: isSocial ?? this.isSocial,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}

class RegisterFailure extends RegisterState {
  final String error;
  const RegisterFailure({
    required this.error,
    super.isPasswordVisible,
    super.isTermsAccepted,
  });

  @override
  List<Object?> get props => [error, isPasswordVisible, isTermsAccepted];

  @override
  RegisterFailure copyWith({
    bool? isPasswordVisible,
    bool? isTermsAccepted,
    String? error,
  }) {
    return RegisterFailure(
      error: error ?? this.error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }
}
