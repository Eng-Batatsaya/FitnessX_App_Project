import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WorkoutDetailHeader extends StatelessWidget {
  const WorkoutDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primaryColor2.withOpacity(0.5),
            colors.primaryColor1.withOpacity(0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: colors.whiteColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          Image.asset(
            'lib/features/home/assets/images/fat7e.png',
            width: 350,
            height: 350,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
