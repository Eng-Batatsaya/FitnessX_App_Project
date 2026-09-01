import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class DailyScheduleCard extends StatelessWidget {
  final VoidCallback onCheckTap;

  const DailyScheduleCard({
    super.key,
    required this.onCheckTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryColor2.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Daily Workout Schedule",
            style: AppTextStyles.heading3.copyWith(color: colors.blackColor),
          ),
          GestureDetector(
            onTap: onCheckTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.primaryGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Check",
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
