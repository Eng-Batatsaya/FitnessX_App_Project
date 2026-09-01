import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/workout_tracker/daily_schedule_card.dart';
import '../widgets/workout_tracker/train_card.dart';
import '../widgets/workout_tracker/upcoming_workout_item.dart';
import '../widgets/workout_tracker/workout_tracker_chart.dart';
import 'home_screen.dart';
import '../controllers/workout_tracker_cubit.dart';
import '../controllers/workout_tracker_state.dart';

class WorkoutTrackerScreen extends StatelessWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutTrackerCubit(),
      child: const WorkoutTrackerView(),
    );
  }
}

class WorkoutTrackerView extends StatelessWidget {
  const WorkoutTrackerView({super.key});

  void _showScheduleDetails(BuildContext context, AppColorsResolved colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Daily Workout Schedule",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.blackColor)),
              const SizedBox(height: 20),
              _buildScheduleItem(
                  colors, "07:00 AM", "Morning Yoga", "30 mins", Icons.wb_sunny_outlined),
              _buildScheduleItem(colors, "11:00 AM", "Fullbody Workout", "45 mins",
                  Icons.fitness_center),
              _buildScheduleItem(
                  colors, "06:00 PM", "Evening Walk", "20 mins", Icons.directions_walk),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(AppColorsResolved colors, String time, String title,
      String duration, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(time, style: TextStyle(color: colors.grayColor1, fontSize: 12)),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryColor1.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primaryColor1, size: 20),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: colors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Text(duration, style: TextStyle(color: colors.grayColor2, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context, AppColorsResolved colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: colors.grayColor3, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              _buildMenuItem(colors, Icons.edit_calendar_outlined, "Edit Training Goals",
                  () {
                Navigator.pop(context);
                _showEditGoalDialog(context, colors);
              }),
              _buildMenuItem(colors, Icons.share_outlined, "Export Progress Report", () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Exporting your progress report..."),
                    backgroundColor: colors.primaryColor1,
                  ),
                );
              }),
              _buildMenuItem(colors, Icons.notifications_active_outlined,
                  "Workout Reminders", () {
                Navigator.pop(context);
                _showReminderPicker(context, colors);
              }),
              _buildMenuItem(colors, Icons.refresh, "Reset This Week", () {
                Navigator.pop(context);
                _showResetConfirmation(context, colors);
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showEditGoalDialog(BuildContext context, AppColorsResolved colors) {
    final controller = TextEditingController(text: "90");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Set Weekly Goal", style: TextStyle(color: colors.blackColor)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: colors.blackColor),
          decoration: const InputDecoration(labelText: "Target Percentage (%)"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? 90;
              context.read<WorkoutTrackerCubit>().updateGoal(val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Goal updated to $val%")),
              );
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showReminderPicker(BuildContext context, AppColorsResolved colors) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder set for ${picked.format(context)}")),
      );
    }
  }

  void _showResetConfirmation(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Reset Week?", style: TextStyle(color: colors.blackColor)),
        content: Text("This will clear all your progress for the current week.",
            style: TextStyle(color: colors.grayColor1)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context.read<WorkoutTrackerCubit>().resetWeek();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Week progress has been reset.")),
              );
            },
            child: const Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      AppColorsResolved colors, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: colors.primaryColor1),
      title: Text(title,
          style: TextStyle(
              color: colors.blackColor, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: colors.grayColor2, size: 20),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, colors),
            _buildContent(context, colors),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsResolved colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  ),
                ),
                Text(
                  "Workout Tracker",
                  style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () => _showMoreMenu(context, colors),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const WorkoutTrackerChart(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppColorsResolved colors) {
    return Container(
      width: double.infinity,
      transform: Matrix4.translationValues(0, -20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: BlocBuilder<WorkoutTrackerCubit, WorkoutTrackerState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.grayColor3.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DailyScheduleCard(onCheckTap: () => _showScheduleDetails(context, colors)),
              const SizedBox(height: 30),
              _buildSectionHeader(
                "Upcoming Workout",
                state.showAllUpcoming ? "See less" : "See more",
                colors,
                onActionTap: () => context.read<WorkoutTrackerCubit>().toggleShowAll(),
              ),
              const SizedBox(height: 20),
              ...(state.showAllUpcoming
                      ? state.upcomingWorkouts
                      : state.upcomingWorkouts.take(2).toList())
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final workout = entry.value;
                return UpcomingWorkoutItem(
                  title: workout.title,
                  subtitle: workout.time,
                  isOn: workout.isOn,
                  imgBgColor: workout.color.withOpacity(0.1),
                  onToggle: (val) =>
                      context.read<WorkoutTrackerCubit>().toggleWorkout(index, val),
                );
              }),
              const SizedBox(height: 30),
              _buildSectionHeader("What Do You Want to Train", null, colors),
              const SizedBox(height: 20),
              TrainCard(
                title: "Fullbody Workout",
                subtitle: "11 Exercises | 32mins",
                bgColor: colors.primaryColor2.withOpacity(0.15),
                imagePath: "assets/images/home/Fullbody.png",
              ),
              const SizedBox(height: 20),
              TrainCard(
                title: "Lowebody Workout",
                subtitle: "12 Exercises | 40mins",
                bgColor: colors.secondaryColor2.withOpacity(0.15),
                imagePath: "assets/images/home/Lowerbody Workout.png",
              ),
              const SizedBox(height: 20),
              TrainCard(
                title: "AB Workout",
                subtitle: "14 Exercises | 20mins",
                bgColor: colors.primaryColor2.withOpacity(0.15),
                imagePath: "assets/images/home/Ab Workout.png",
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? actionText, AppColorsResolved colors,
      {VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: TextStyle(color: colors.grayColor2, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
