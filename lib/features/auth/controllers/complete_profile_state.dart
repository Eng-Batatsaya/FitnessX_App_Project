import 'package:equatable/equatable.dart';

enum CompleteProfileStatus { initial, loading, success, failure }

class CompleteProfileState extends Equatable {
  final String? gender;
  final DateTime? dateOfBirth;
  final String? weight;
  final String? height;
  final CompleteProfileStatus status;
  final String? errorMessage;

  const CompleteProfileState({
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.status = CompleteProfileStatus.initial,
    this.errorMessage,
  });

  CompleteProfileState copyWith({
    String? gender,
    DateTime? dateOfBirth,
    String? weight,
    String? height,
    CompleteProfileStatus? status,
    String? errorMessage,
  }) {
    return CompleteProfileState(
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [gender, dateOfBirth, weight, height, status, errorMessage];
}
