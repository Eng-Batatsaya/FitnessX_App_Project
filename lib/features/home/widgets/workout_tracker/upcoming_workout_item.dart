import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class UpcomingWorkoutItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isOn;
  final Color imgBgColor;
  final ValueChanged<bool> onToggle;

  const UpcomingWorkoutItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isOn,
    required this.imgBgColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: imgBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.fitness_center,
                color: colors.primaryColor1.withOpacity(0.5)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                const SizedBox(height: 5),
                Text(subtitle,
                    style:
                        AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isOn,
              onChanged: onToggle,
              activeThumbColor: Colors.white,
              activeTrackColor: colors.secondaryColor1,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: colors.grayColor3,
            ),
          ),
        ],
      ),
    );
  }
}
