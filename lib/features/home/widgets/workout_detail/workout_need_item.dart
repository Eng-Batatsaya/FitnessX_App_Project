import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WorkoutNeedItem extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkoutNeedItem({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primaryColor2.withOpacity(0.1)
                        : colors.grayColor3.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(color: colors.primaryColor1, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(label,
                style: AppTextStyles.bodyMedium.copyWith(color: colors.blackColor)),
          ],
        ),
      ),
    );
  }
}
