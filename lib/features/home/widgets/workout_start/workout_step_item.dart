import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WorkoutStepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final bool showLine;

  const WorkoutStepItem({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(number, style: TextStyle(color: colors.secondaryColor1, fontSize: 14)),
              const SizedBox(height: 5),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.secondaryColor1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.secondaryColor1,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: colors.secondaryColor1.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 14, color: colors.blackColor)),
                  const SizedBox(height: 5),
                  Text(description, style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
