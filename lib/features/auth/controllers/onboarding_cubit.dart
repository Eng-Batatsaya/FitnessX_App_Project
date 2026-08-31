import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

/// Cubit to manage onboarding screen state
class OnboardingCubit extends Cubit<OnboardingState> {
  final int totalPages;

  OnboardingCubit({required this.totalPages}) : super(OnboardingState.initial());

  /// Called when the PageView changes the page
  void onPageChanged(int index) {
    emit(state.copyWith(
      currentIndex: index,
      isLastPage: index == totalPages - 1,
    ));
  }

  /// Determines if we should navigate to the next screen or the next page
  /// Returns true if navigation to Login is required
  bool shouldNavigate() {
    return state.isLastPage;
  }
}
