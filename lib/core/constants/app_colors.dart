import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';

class AppColors {
  // Brand colors — identical in light & dark mode
  // (gradients/brand identity should not change with theme).
  static const Color primaryColor1 = Color(0xFF92A3FD);
  static const Color primaryColor2 = Color(0xFF9DCEFF);

  static const Color secondaryColor1 = Color(0xFFC58BF2);
  static const Color secondaryColor2 = Color(0xFFEEA4CE);

  // ---- Static (legacy) light-mode values ----
  // Kept for any code that references AppColors.xxx directly without
  // context. Prefer AppColors.of(context).xxx in new/updated widgets so
  // surfaces correctly flip with dark mode.
  static const Color blackColor = Color(0xFF1D1617);
  static const Color grayColor1 = Color(0xFF7B6F72);
  static const Color grayColor2 = Color(0xFFADA4A5);
  static const Color grayColor3 = Color(0xFFDDDADA);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color bgColor = Color(0xFFF7F8F8);

  // ---- Dark-mode equivalents ----
  static const Color blackColorDark = Color(0xFFF5F5F5);
  static const Color grayColor1Dark = Color(0xFFC9C0C2);
  static const Color grayColor2Dark = Color(0xFF9A9192);
  static const Color grayColor3Dark = Color(0xFF3A3638);
  static const Color whiteColorDark = Color(0xFF1E1B1D);
  static const Color bgColorDark = Color(0xFF121012);

  // ---- Social/Auth colors ----
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color socialButtonBg = Color(0xFFF7F8F8);

  static List<Color> get primaryGradient => [
    primaryColor2,
    primaryColor1,
  ];

  static List<Color> get secondaryGradient => [
    secondaryColor2,
    secondaryColor1,
  ];

  /// Theme-aware accessor.
  ///
  /// Use AppColors.of(context).blackColor etc.
  /// so widgets automatically adapt to dark mode without needing
  /// to know about ThemeController directly.
  static AppColorsResolved of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppColorsResolved(isDark);
  }
}

class AppColorsResolved {
  final bool isDark;

  const AppColorsResolved(this.isDark);

  Color get blackColor =>
      isDark ? AppColors.blackColorDark : AppColors.blackColor;

  Color get grayColor1 =>
      isDark ? AppColors.grayColor1Dark : AppColors.grayColor1;

  Color get grayColor2 =>
      isDark ? AppColors.grayColor2Dark : AppColors.grayColor2;

  Color get grayColor3 =>
      isDark ? AppColors.grayColor3Dark : AppColors.grayColor3;

  Color get whiteColor =>
      isDark ? AppColors.whiteColorDark : AppColors.whiteColor;

  Color get bgColor =>
      isDark ? AppColors.bgColorDark : AppColors.bgColor;

  // Brand colors stay constant across themes.
  Color get primaryColor1 => AppColors.primaryColor1;

  Color get primaryColor2 => AppColors.primaryColor2;

  Color get secondaryColor1 => AppColors.secondaryColor1;

  Color get secondaryColor2 => AppColors.secondaryColor2;

  List<Color> get primaryGradient => AppColors.primaryGradient;

  List<Color> get secondaryGradient => AppColors.secondaryGradient;
}