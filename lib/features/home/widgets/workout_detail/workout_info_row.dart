import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WorkoutInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  const WorkoutInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color ?? colors.primaryColor2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.grayColor1, size: 20),
            const SizedBox(width: 10),
            Text(title,
                style: AppTextStyles.bodyMedium.copyWith(color: colors.grayColor1)),
            const Spacer(),
            Text(value,
                style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
            const SizedBox(width: 5),
            Icon(Icons.chevron_right, color: colors.grayColor2, size: 18),
          ],
        ),
      ),
    );
  }
}
