import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/controllers/theme_cubit.dart';
import '../../../core/controllers/theme_state.dart';
import '../screens/notification_screen.dart';
import '../screens/search_screen.dart';
import '../screens/profile_settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back,",
                  style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  "Ana",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.blackColor,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                );
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: colors.primaryColor2.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "https://via.placeholder.com/150",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: colors.primaryColor1);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dark / Light mode toggle
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final isDark = state.isDarkMode;
                return GestureDetector(
                  onTap: () => context.read<ThemeCubit>().toggleTheme(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                          size: 18,
                          color: colors.blackColor,
                        ),
                        const SizedBox(width: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 35,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.blackColor.withOpacity(0.1)),
                          ),
                          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: colors.blackColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                _buildIconBox(context, Icons.search, false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                }, colors),
                const SizedBox(width: 15),
                _buildIconBox(context, Icons.notifications_none_rounded, true, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                }, colors),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconBox(BuildContext context, IconData icon, bool hasNotification, VoidCallback onTap, AppColorsResolved colors) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primaryColor2.withOpacity(0.4),
                  colors.primaryColor2.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 28, color: colors.blackColor.withOpacity(0.87)),
          ),
          if (hasNotification)
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
