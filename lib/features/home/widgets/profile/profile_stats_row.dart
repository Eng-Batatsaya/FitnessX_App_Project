import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileStatsRow extends StatelessWidget {
  final String height;
  final String weight;
  final String age;

  const ProfileStatsRow({
    super.key,
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Expanded(child: _buildStatItem(height, "Height", colors)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatItem(weight, "Weight", colors)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatItem(age, "Age", colors)),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, AppColorsResolved colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: colors.primaryColor1,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: colors.grayColor2, fontSize: 12)),
        ],
      ),
    );
  }
}
