import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: colors.primaryColor2.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/images/home/Profile.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, color: colors.primaryColor1, size: 20);
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.heading3
                      .copyWith(fontSize: 12, color: colors.blackColor)),
              Text(time, style: TextStyle(fontSize: 10, color: colors.grayColor2)),
            ],
          ),
        ),
        Icon(Icons.more_vert, color: colors.grayColor2),
      ],
    );
  }
}
