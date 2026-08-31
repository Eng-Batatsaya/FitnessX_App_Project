import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// States for the Welcome Screen
/// We use this to signal when it's time to navigate
enum WelcomeState { initial, navigateToOnboarding }

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(WelcomeState.initial);

  Timer? _timer;

  /// Starts a 10-second timer to automatically transition to onboarding
  void startTimer() {
    // We cancel any existing timer just in case
    _timer?.cancel();
    
    // Set a timer for 5 seconds
    _timer = Timer(const Duration(seconds: 2), () {

      emit(WelcomeState.navigateToOnboarding);
    });
  }

  /// Called if the user clicks the "Get Started" button manually
  void onGetStartedPressed() {
    _timer?.cancel();
    emit(WelcomeState.navigateToOnboarding);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
