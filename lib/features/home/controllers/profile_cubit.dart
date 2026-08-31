import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void updateProfile({
    String? name,
    String? program,
    String? height,
    String? weight,
    String? age,
  }) {
    emit(state.copyWith(
      name: name,
      program: program,
      height: height,
      weight: weight,
      age: age,
    ));
  }

  void toggleNotification(bool isOn) {
    emit(state.copyWith(isNotificationOn: isOn));
  }
}
