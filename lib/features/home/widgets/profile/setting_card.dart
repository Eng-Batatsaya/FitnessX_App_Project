import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const SettingCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.blackColor,
            ),
          ),
          const SizedBox(height: 20),
          ...items.expand((item) => [
                item,
                if (items.indexOf(item) != items.length - 1)
                  const SizedBox(height: 15),
              ]),
        ],
      ),
    );
  }
}
