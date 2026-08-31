/// State for the onboarding flow
class OnboardingState {
  final int currentIndex;
  final bool isLastPage;

  const OnboardingState({
    required this.currentIndex,
    required this.isLastPage,
  });

  factory OnboardingState.initial() => const OnboardingState(
        currentIndex: 0,
        isLastPage: false,
      );

  OnboardingState copyWith({
    int? currentIndex,
    bool? isLastPage,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingState &&
          runtimeType == other.runtimeType &&
          currentIndex == other.currentIndex &&
          isLastPage == other.isLastPage;

  @override
  int get hashCode => currentIndex.hashCode ^ isLastPage.hashCode;
}
