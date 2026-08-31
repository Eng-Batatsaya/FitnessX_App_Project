import 'package:flutter/material.dart';

class AppColors {
  // ============================================================
  // BRAND COLORS
  // These colors stay the same in Light & Dark mode.
  // ============================================================

  static const Color primaryColor1 = Color(0xFF92A3FD);
  static const Color primaryColor2 = Color(0xFF9DCEFF);

  static const Color secondaryColor1 = Color(0xFFC58BF2);
  static const Color secondaryColor2 = Color(0xFFEEA4CE);

  // ============================================================
  // BASMALA - LIGHT MODE COLORS
  // ============================================================

  static const Color blackColor = Color(0xFF1D1617);
  static const Color grayColor1 = Color(0xFF7B6F72);
  static const Color grayColor2 = Color(0xFFADA4A5);
  static const Color grayColor3 = Color(0xFFDDDADA);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color bgColor = Color(0xFFF7F8F8);

  // ============================================================
  // BASMALA - DARK MODE COLORS
  // ============================================================

  static const Color blackColorDark = Color(0xFFF5F5F5);
  static const Color grayColor1Dark = Color(0xFFC9C0C2);
  static const Color grayColor2Dark = Color(0xFF9A9192);
  static const Color grayColor3Dark = Color(0xFF3A3638);
  static const Color whiteColorDark = Color(0xFF1E1B1D);
  static const Color bgColorDark = Color(0xFF121012);

  // ============================================================
  // KERLOS / AUTH COLORS
  // Keep these because existing authentication screens use them.
  // ============================================================

  static const Color background = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF1D1617);

  static const Color gray1 = Color(0xFF7B6F72);

  static const Color gray2 = Color(0xFFADA4A5);

  static const Color gray3 = Color(0xFFDDDADA);

  static const Color border = Color(0xFFF7F8F8);

  // ============================================================
  // PRIMARY GRADIENT
  // ============================================================

  static const List<Color> primaryGradient = [
    Color(0xFF92A3FD),
    Color(0xFF9DCEFF),
  ];

  // ============================================================
  // SECONDARY GRADIENT
  // ============================================================

  static const List<Color> secondaryGradient = [
    Color(0xFFEEA4CE),
    Color(0xFFC58BF2),
  ];

  // ============================================================
  // SOCIAL LOGIN COLORS
  // ============================================================

  static const Color facebookBlue = Color(0xFF1877F2);

  static const Color googleRed = Color(0xFFEA4335);

  static const Color socialButtonBg = Color(0xFFF7F8F8);

  // ============================================================
  // THEME-AWARE ACCESSOR
  // ============================================================

  /// Use:
  ///
  /// final colors = AppColors.of(context);
  ///
  /// Then:
  ///
  /// colors.blackColor
  /// colors.grayColor1
  /// colors.whiteColor
  /// colors.bgColor
  ///
  /// These values automatically change according to the theme.
  static AppColorsResolved of(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return AppColorsResolved(isDark);
  }
}

// ================================================================
// THEME-AWARE COLORS
// ================================================================

class AppColorsResolved {
final bool isDark;

const AppColorsResolved(this.isDark);

// ------------------------------------------------------------
// Theme-aware basic colors
// ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // Brand colors
  // Same in Light & Dark mode
  // ------------------------------------------------------------

  Color get primaryColor1 => AppColors.primaryColor1;

  Color get primaryColor2 => AppColors.primaryColor2;

  Color get secondaryColor1 => AppColors.secondaryColor1;

  Color get secondaryColor2 => AppColors.secondaryColor2;

  List<Color> get primaryGradient =>
      AppColors.primaryGradient;

  List<Color> get secondaryGradient =>
      AppColors.secondaryGradient;

  // ------------------------------------------------------------
  // Authentication / Social colors
  // Keep the original colors available through the resolved object
  // ------------------------------------------------------------

  Color get background => AppColors.background;

  Color get white => AppColors.white;

  Color get black => AppColors.black;

  Color get gray1 => AppColors.gray1;

  Color get gray2 => AppColors.gray2;

  Color get gray3 => AppColors.gray3;

  Color get border => AppColors.border;

  Color get facebookBlue => AppColors.facebookBlue;

  Color get googleRed => AppColors.googleRed;

  Color get socialButtonBg => AppColors.socialButtonBg;
}