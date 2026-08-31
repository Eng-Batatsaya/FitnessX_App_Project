import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WorkoutVideoHeader extends StatelessWidget {
  const WorkoutVideoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.all(20),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primaryColor2.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('lib/features/home/assets/images/fullbody workout2 (3).png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colors.whiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: colors.primaryColor1),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.whiteColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.close, color: colors.blackColor, size: 20),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.more_horiz, color: colors.blackColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
