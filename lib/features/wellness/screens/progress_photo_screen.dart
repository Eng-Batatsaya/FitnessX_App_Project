import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../home/widgets/custom_bottom_nav_bar.dart';

class ProgressPhotoScreen extends StatelessWidget {
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      appBar: AppBar(
        title: Text("Progress Photo", style: AppTextStyles.heading1.copyWith(color: colors.blackColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Text("Progress Photo Feature Coming Soon", style: AppTextStyles.bodyLarge.copyWith(color: colors.grayColor1)),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
    );
  }
}
