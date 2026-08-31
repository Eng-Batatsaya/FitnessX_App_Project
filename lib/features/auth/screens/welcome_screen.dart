import 'package:fitness_app/features/auth/controllers/welcome_cubit.dart';
import 'package:fitness_app/features/auth/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap the screen with BlocProvider so the Cubit is available
    return BlocProvider(
      create: (context) => WelcomeCubit()..startTimer(),
      child: const WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listener: (context, state) {
        // If the state changes to navigateToOnboarding, we push the next screen
        if (state == WelcomeState.navigateToOnboarding) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const OnboardingScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Using an easeInOutCubic curve for smooth "physics-like" motion
                const curve = Curves.easeInOutCubic;
                var curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                // We combine a Fade and a slight Scale down for a premium feel
                return FadeTransition(
                  opacity: curvedAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1.1, end: 1.0).animate(curvedAnimation),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // Applying a linear gradient background as seen in the design
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFC5D3FF), // Light blue top
                Color(0xFF92A3FD), // Deeper blue bottom
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo Section: "FitnestX"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fitnest',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'X',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Subtitle
                  const Text(
                    'Diet & Fitness',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  // "Get Started" Button at the bottom
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // Notify cubit that user wants to start
                        context.read<WelcomeCubit>().onGetStartedPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1617), // Dark button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
