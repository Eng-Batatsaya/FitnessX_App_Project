import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/onboarding_cubit.dart';
import '../controllers/onboarding_state.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_image_view.dart';
import '../widgets/onboarding_content_view.dart';
import 'login_screen.dart';

/// The main Onboarding Screen that coordinates the images and content.
/// Notice: The images swipe while the text and button remain fixed.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  // Data for the onboarding screens
  final List<OnboardingModel> _items = [
    OnboardingModel(
      title: 'Track Your Goal',
      description:
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      imagePath: 'lib/features/auth/assets/images/OnBoarding01.png',
    ),
    OnboardingModel(
      title: 'Get Burn',
      description:
          "Let's keep burning, to achieve yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      imagePath: 'lib/features/auth/assets/images/OnBoarding02.png',
    ),
    OnboardingModel(
      title: 'Eat Well',
      description:
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      imagePath: 'lib/features/auth/assets/images/OnBoarding03.png',
    ),
    OnboardingModel(
      title: 'Improve Sleep Quality',
      description:
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      imagePath: 'lib/features/auth/assets/images/OnBoarding04.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles the action button press
  void _handleNext(BuildContext context, OnboardingState state) {
    final cubit = context.read<OnboardingCubit>();
    
    if (cubit.shouldNavigate()) {
      // Navigate to Login Screen with a smooth physics-like animation
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Using a Slide transition from the right with a smooth curve
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            // Curves.easeOutQuart gives a smooth "physics-like" deceleration
            const curve = Curves.easeOutQuart;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            // Combining slide with a slight fade for a premium feel
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    } else {
      // Swipe to the next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(totalPages: _items.length),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                // Top Section: Swiping Images
                // notice number 2 : only the image moves
                SizedBox(
                  height: 500, // keep the images with the default height 500px
                  child: OnboardingImageView(
                    items: _items,
                    pageController: _pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingCubit>().onPageChanged(index);
                    },
                  ),
                ),
                
                // Bottom Section: Fixed Text and Button
                Expanded(
                  child: OnboardingContentView(
                    items: _items,
                    onNextPressed: () => _handleNext(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
