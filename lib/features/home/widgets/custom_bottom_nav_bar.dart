import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../screens/home_screen.dart';
import '../screens/activity_tracker_screen.dart';
import '../screens/workout_tracker_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../../wellness/screens/progress_photo_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context,
            colors,
            Icons.home_outlined,
            Icons.home_filled,
            0,
            const HomeScreen(),
          ),
          _buildNavItem(
            context,
            colors,
            Icons.bar_chart_outlined,
            Icons.bar_chart,
            1,
            const ActivityTrackerScreen(),
          ),
          _buildCenterNavItem(context),
          _buildNavItem(
            context,
            colors,
            Icons.camera_alt_outlined,
            Icons.camera_alt,
            3,
            const ProgressPhotoScreen(),
          ),
          _buildNavItem(
            context,
            colors,
            Icons.person_outline,
            Icons.person,
            4,
            const ProfileSettingsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    dynamic colors,
    IconData icon,
    IconData activeIcon,
    int index,
    Widget? screen,
  ) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isActive && screen != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.secondaryColor1 : colors.grayColor2,
            size: 28,
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor1,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCenterNavItem(BuildContext context) {
    bool isActive = selectedIndex == 2;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutTrackerScreen()),
          );
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.primaryGradient),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor1.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
