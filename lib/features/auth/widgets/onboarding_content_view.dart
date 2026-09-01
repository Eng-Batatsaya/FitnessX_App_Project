import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/onboarding_cubit.dart';
import '../controllers/onboarding_state.dart';
import '../models/onboarding_model.dart';

/// A fixed widget that displays onboarding title, description, and action button.
/// Notice: This part remains static while images swipe above it.
class OnboardingContentView extends StatelessWidget {
  final List<OnboardingModel> items;
  final VoidCallback onNextPressed;

  const OnboardingContentView({
    super.key,
    required this.items,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final currentItem = items[state.currentIndex];
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                currentItem.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              // Description
              Text(
                currentItem.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Spacer(), // Pushes the button to the bottom
              // Action Button (Full Width)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF92A3FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    state.isLastPage ? 'LogIn' : 'Continue',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
