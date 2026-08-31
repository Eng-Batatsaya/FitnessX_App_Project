import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.onChanged,
    this.keyboardType,
    this.backgroundColor,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.border,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        onChanged: onChanged,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          color: (backgroundColor == AppColors.black) ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.gray2),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.gray2) : null,
          suffixIcon: suffixIcon ?? (isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.gray1,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
