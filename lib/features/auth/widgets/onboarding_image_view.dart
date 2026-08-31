import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

/// A widget that displays the swiping images for the onboarding screen.
/// Notice: Only this part moves during swiping.
class OnboardingImageView extends StatelessWidget {
  final List<OnboardingModel> items;
  final PageController pageController;
  final Function(int) onPageChanged;

  const OnboardingImageView({
    super.key,
    required this.items,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // background color of the photo part is white
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Adjust the vertical position for each photo separately
          // Negative values move the image UP, positive values move it DOWN
          double yOffset = 0.0;
          
          switch (index) {
            case 0:
              yOffset = 0.0; // Adjust for Photo 1
              break;
            case 1:
              yOffset = -12.5; // Adjust for Photo 2
              break;
            case 2:
              yOffset = -44.0; // Adjust for Photo 3
              break;
            case 3:
              yOffset = 0.0; // Adjust for Photo 4
              break;
          }

          return Transform.translate(
            offset: Offset(0, yOffset),
            child: Image.asset(
              items[index].imagePath,
              height: 500, // keep the images with the default height 500px
              fit: BoxFit.contain, // dont change any ratios in the photo
              alignment: Alignment.topCenter,
            ),
          );
        },
      ),
    );
  }
}
