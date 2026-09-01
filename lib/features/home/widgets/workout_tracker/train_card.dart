import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../screens/workout_detail_screen.dart';

class TrainCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final String imagePath;

  const TrainCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                const SizedBox(height: 5),
                Text(subtitle,
                    style:
                        AppTextStyles.bodySmall.copyWith(color: colors.grayColor1)),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkoutDetailScreen()),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "View more",
                      style: TextStyle(
                          color: colors.primaryColor1,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colors.whiteColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              Image.asset(imagePath, width: 90, height: 90, fit: BoxFit.contain),
            ],
          ),
        ],
      ),
    );
  }
}
