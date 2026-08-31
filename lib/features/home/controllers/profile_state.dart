import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String program;
  final String height;
  final String weight;
  final String age;
  final bool isNotificationOn;

  const ProfileState({
    this.name = "Amir",
    this.program = "Lose a Fat Program",
    this.height = "180cm",
    this.weight = "65kg",
    this.age = "22yo",
    this.isNotificationOn = true,
  });

  ProfileState copyWith({
    String? name,
    String? program,
    String? height,
    String? weight,
    String? age,
    bool? isNotificationOn,
  }) {
    return ProfileState(
      name: name ?? this.name,
      program: program ?? this.program,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
    );
  }

  @override
  List<Object?> get props => [name, program, height, weight, age, isNotificationOn];
}
