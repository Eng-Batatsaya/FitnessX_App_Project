import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../screens/workout_tracker_screen.dart';

class LatestWorkoutList extends StatelessWidget {
  const LatestWorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Latest Workout", style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutTrackerScreen()),
                );
              },
              child: Text("See more", style: TextStyle(color: colors.grayColor2, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildWorkoutItem(
          context,
          colors,
          "Fullbody Workout",
          "180 Calories Burn | 20minutes",
          0.5,
          "assets/images/home/Fullbody.png",
        ),
        _buildWorkoutItem(
          context,
          colors,
          "Lowerbody Workout",
          "200 Calories Burn | 30minutes",
          0.6,
          "assets/images/home/Lowerbody Workout.png",
          isHighlighted: true,
        ),
        _buildWorkoutItem(
          context,
          colors,
          "Ab Workout",
          "180 Calories Burn | 20minutes",
          0.4,
          "assets/images/home/Ab Workout.png",
        ),
      ],
    );
  }

  Widget _buildWorkoutItem(BuildContext context, dynamic colors, String title, String subtitle, double progress, String imageUrl, {bool isHighlighted = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutTrackerScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isHighlighted 
              ? [
                  BoxShadow(
                    color: colors.grayColor3.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: colors.grayColor3.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor2.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: imageUrl.startsWith("http") 
                  ? Image.network(imageUrl, fit: BoxFit.contain)
                  : Image.asset(imageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 14, color: colors.blackColor)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 12, color: colors.grayColor1)),
                  const SizedBox(height: 10),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.grayColor3.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: AppColors.primaryGradient),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.grayColor3),
              ),
              child: Icon(Icons.chevron_right, color: colors.grayColor2, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
