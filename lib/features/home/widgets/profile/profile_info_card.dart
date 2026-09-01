import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String program;
  final VoidCallback onEditTap;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.program,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: colors.primaryColor2.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/images/home/Profile.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, color: colors.primaryColor1);
              },
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
              Text(program,
                  style:
                      AppTextStyles.bodySmall.copyWith(color: colors.grayColor1)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.primaryGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Edit",
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
