import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath; // Using icon path for custom images if needed, or IconData
  final VoidCallback onPressed;
  final bool isGoogle;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.isGoogle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.gray1.withAlpha(51)), // 0.2 * 255 = 51
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using local SVG for Google and Icon for Facebook
              isGoogle
                  ? SvgPicture.asset(
                      'lib/features/auth/assets/logos/google.svg',
                      height: 25,
                      width: 25,
                    )
                  : const Icon(
                      Icons.facebook,
                      color: AppColors.facebookBlue,
                      size: 30,
                    ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
