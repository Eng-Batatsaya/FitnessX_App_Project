import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/profile/profile_info_card.dart';
import '../widgets/profile/profile_stats_row.dart';
import '../widgets/profile/setting_card.dart';
import '../widgets/profile/setting_item.dart';
import 'home_screen.dart';
import '../controllers/profile_cubit.dart';
import '../controllers/profile_state.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: const ProfileSettingsView(),
    );
  }
}

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(context, colors),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ProfileInfoCard(
                          name: state.name,
                          program: state.program,
                          onEditTap: () => _showEditProfileDialog(context, colors, state),
                        ),
                        const SizedBox(height: 30),
                        ProfileStatsRow(
                          height: state.height,
                          weight: state.weight,
                          age: state.age,
                        ),
                        const SizedBox(height: 30),
                        _buildAccountSection(context, colors, state),
                        const SizedBox(height: 30),
                        _buildNotificationSection(context, colors, state),
                        const SizedBox(height: 30),
                        _buildOtherSection(context, colors),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 4),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsResolved colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.grayColor3.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.chevron_left, color: colors.blackColor),
            ),
          ),
          Text(
            "Profile",
            style: AppTextStyles.heading1.copyWith(color: colors.blackColor),
          ),
          const SizedBox(width: 40), // Spacing to balance the back button
        ],
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, AppColorsResolved colors, ProfileState state) {
    final nameController = TextEditingController(text: state.name);
    final programController = TextEditingController(text: state.program);
    final heightController =
        TextEditingController(text: state.height.replaceAll(RegExp(r'[^0-9]'), ''));
    final weightController =
        TextEditingController(text: state.weight.replaceAll(RegExp(r'[^0-9]'), ''));
    final ageController =
        TextEditingController(text: state.age.replaceAll(RegExp(r'[^0-9]'), ''));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Edit Profile",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField("Name", nameController, colors),
              _buildEditField("Program", programController, colors),
              _buildEditField("Height", heightController, colors,
                  isNumber: true, suffix: "cm"),
              _buildEditField("Weight", weightController, colors,
                  isNumber: true, suffix: "kg"),
              _buildEditField("Age", ageController, colors,
                  isNumber: true, suffix: "yo"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: colors.grayColor2)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileCubit>().updateProfile(
                    name: nameController.text,
                    program: programController.text,
                    height: heightController.text.isEmpty
                        ? state.height
                        : "${heightController.text}cm",
                    weight: weightController.text.isEmpty
                        ? state.weight
                        : "${weightController.text}kg",
                    age: ageController.text.isEmpty ? state.age : "${ageController.text}yo",
                  );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryColor1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    AppColorsResolved colors, {
    bool isNumber = false,
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.grayColor1),
          suffixText: suffix,
          suffixStyle:
              TextStyle(color: colors.grayColor1, fontWeight: FontWeight.bold),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: colors.primaryColor1)),
        ),
      ),
    );
  }

  void _showPersonalDataDialog(
      BuildContext context, AppColorsResolved colors, ProfileState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Personal Data",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDataRow("Name", state.name, colors),
            _buildDataRow("Program", state.program, colors),
            _buildDataRow("Height", state.height, colors),
            _buildDataRow("Weight", state.weight, colors),
            _buildDataRow("Age", state.age, colors),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, AppColorsResolved colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.grayColor1, fontSize: 14)),
          Text(value,
              style: TextStyle(
                  color: colors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  void _showAchievementDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Achievements",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAchievementItem(
                "First Workout", "Completed your first session", Icons.star, colors),
            _buildAchievementItem("7 Day Streak", "Worked out for 7 days in a row",
                Icons.whatshot, colors),
            _buildAchievementItem(
                "Weight Loss", "Reached your first 5kg goal", Icons.trending_down, colors),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String desc, IconData icon, AppColorsResolved colors) {
    return ListTile(
      leading: const Icon(Icons.star, color: Colors.amber),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
    );
  }

  void _showActivityHistoryDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Activity History",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildHistoryItem("Fullbody Workout", "27 May, 09:00 AM", colors),
              _buildHistoryItem("Yoga Session", "25 May, 06:00 PM", colors),
              _buildHistoryItem("Cardio Blitz", "23 May, 07:30 AM", colors),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date, AppColorsResolved colors) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(date, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
    );
  }

  void _showWorkoutProgressDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Workout Progress",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDataRow("Total Workouts", "15", colors),
            _buildDataRow("Calories Burned", "3,250 kcal", colors),
            _buildDataRow("Active Minutes", "480 mins", colors),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: colors.grayColor3,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primaryColor1),
            ),
            const SizedBox(height: 5),
            Text("70% of Weekly Goal",
                style: TextStyle(color: colors.grayColor1, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  void _showContactUsDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Contact Us",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: support@fitnessx.com",
                style: TextStyle(color: colors.grayColor1, fontSize: 14)),
            const SizedBox(height: 10),
            Text("Phone: +1 234 567 890",
                style: TextStyle(color: colors.grayColor1, fontSize: 14)),
            const SizedBox(height: 10),
            Text("Hours: Mon-Fri, 9AM - 6PM",
                style: TextStyle(color: colors.grayColor1, fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Privacy Policy",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: SingleChildScrollView(
          child: Text(
            "At FitnessX, we value your privacy. We collect data to improve your workout experience, such as your height, weight, and activity history. Your data is stored securely and never shared with third parties without your consent. By using our app, you agree to our terms of service and privacy policy.",
            style: TextStyle(color: colors.grayColor1, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("App Settings",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDataRow("Language", "English", colors),
            _buildDataRow("Units", "Metric (kg, cm)", colors),
            _buildDataRow("App Version", "1.0.0", colors),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(
      BuildContext context, AppColorsResolved colors, ProfileState state) {
    return SettingCard(
      title: "Account",
      items: [
        SettingItem(
            icon: Icons.person_outline,
            title: "Personal Data",
            onTap: () {
              _showPersonalDataDialog(context, colors, state);
            }),
        SettingItem(
            icon: Icons.badge_outlined,
            title: "Achievement",
            onTap: () {
              _showAchievementDialog(context, colors);
            }),
        SettingItem(
            icon: Icons.history,
            title: "Activity History",
            onTap: () {
              _showActivityHistoryDialog(context, colors);
            }),
        SettingItem(
            icon: Icons.bar_chart_outlined,
            title: "Workout Progress",
            onTap: () {
              _showWorkoutProgressDialog(context, colors);
            }),
      ],
    );
  }

  Widget _buildNotificationSection(
      BuildContext context, AppColorsResolved colors, ProfileState state) {
    return SettingCard(
      title: "Notification",
      items: [
        Row(
          children: [
            Icon(Icons.notifications_none_outlined,
                color: colors.primaryColor1, size: 20),
            const SizedBox(width: 15),
            Expanded(
                child: Text("Pop-up Notification",
                    style: TextStyle(color: colors.grayColor1, fontSize: 12))),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: state.isNotificationOn,
                onChanged: (value) => context.read<ProfileCubit>().toggleNotification(value),
                activeThumbColor: colors.secondaryColor1,
                activeTrackColor: colors.secondaryColor1.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherSection(BuildContext context, AppColorsResolved colors) {
    return SettingCard(
      title: "Other",
      items: [
        SettingItem(
            icon: Icons.mail_outline,
            title: "Contact Us",
            onTap: () {
              _showContactUsDialog(context, colors);
            }),
        SettingItem(
            icon: Icons.verified_user_outlined,
            title: "Privacy Policy",
            onTap: () {
              _showPrivacyPolicyDialog(context, colors);
            }),
        SettingItem(
            icon: Icons.settings_outlined,
            title: "Settings",
            onTap: () {
              _showSettingsDialog(context, colors);
            }),
      ],
    );
  }
}
