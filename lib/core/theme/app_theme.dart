import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor1,
      scaffoldBackgroundColor: AppColors.bgColor,
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor1,
        brightness: Brightness.light,
        surface: AppColors.whiteColor,
        onSurface: AppColors.blackColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blackColor),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor1,
      scaffoldBackgroundColor: AppColors.bgColorDark,
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor1,
        brightness: Brightness.dark,
        surface: AppColors.whiteColorDark,
        onSurface: AppColors.blackColorDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.whiteColorDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blackColorDark),
      ),
    );
  }
}
