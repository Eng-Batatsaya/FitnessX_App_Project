import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/dashboard_data.dart';

class TodayTargetSection extends StatelessWidget {
  final DashboardData data;
  final VoidCallback onAddTap;
  final VoidCallback onWaterTap;
  final VoidCallback onStepsTap;

  const TodayTargetSection({
    super.key,
    required this.data,
    required this.onAddTap,
    required this.onWaterTap,
    required this.onStepsTap,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today Target",
                  style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
              GestureDetector(
                onTap: onAddTap,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.primaryGradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTargetItem(
                  colors,
                  "${data.waterGoal.toInt()}L",
                  "Water Intake",
                  "assets/images/home/Water Intake.png",
                  colors.primaryColor1,
                  onTap: onWaterTap,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTargetItem(
                  colors,
                  "${data.stepsGoal}",
                  "Foot Steps",
                  "assets/images/home/Foot Steps.png",
                  colors.secondaryColor1,
                  onTap: onStepsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetItem(AppColorsResolved colors, String value, String label,
      String imagePath, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 30, height: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(label,
                      style: TextStyle(color: colors.grayColor2, fontSize: 10),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
