import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/dashboard_data.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/activity_tracker/activity_progress_chart.dart';
import '../widgets/activity_tracker/latest_activity_list.dart';
import '../widgets/activity_tracker/today_target_section.dart';
import 'home_screen.dart';
import '../controllers/activity_tracker_cubit.dart';
import '../controllers/activity_tracker_state.dart';

class ActivityTrackerScreen extends StatelessWidget {
  final DashboardData? data;

  const ActivityTrackerScreen({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityTrackerCubit(data),
      child: const ActivityTrackerView(),
    );
  }
}

class ActivityTrackerView extends StatelessWidget {
  const ActivityTrackerView({super.key});

  void _showEditDialog(
      BuildContext context, AppColorsResolved colors, DashboardData data) {
    final waterController = TextEditingController(text: data.waterGoal.toString());
    final stepsController = TextEditingController(text: data.stepsGoal.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Edit Today Target", style: TextStyle(color: colors.blackColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: waterController,
                style: TextStyle(color: colors.blackColor),
                decoration: InputDecoration(
                  labelText: "Water Goal (Liters)",
                  labelStyle: TextStyle(color: colors.grayColor1),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colors.grayColor3)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stepsController,
                style: TextStyle(color: colors.blackColor),
                decoration: InputDecoration(
                  labelText: "Steps Goal",
                  labelStyle: TextStyle(color: colors.grayColor1),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colors.grayColor3)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Text("Suggestions:",
                  style: TextStyle(
                      color: colors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSuggestionChip(
                      colors, "2L Water", () => waterController.text = "2"),
                  _buildSuggestionChip(
                      colors, "4L Water", () => waterController.text = "4"),
                  _buildSuggestionChip(
                      colors, "5000 Steps", () => stepsController.text = "5000"),
                  _buildSuggestionChip(
                      colors, "10000 Steps", () => stepsController.text = "10000"),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: colors.grayColor1)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.primaryGradient),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.read<ActivityTrackerCubit>().updateGoals(
                      waterGoal: double.tryParse(waterController.text),
                      stepsGoal: int.tryParse(stepsController.text),
                    );
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMoreMenu(
      BuildContext context, String value, AppColorsResolved colors, DashboardData data) {
    switch (value) {
      case "goals":
        _showEditDialog(context, colors, data);
        break;
      case "history":
        _showFullHistoryDialog(context, colors, data);
        break;
      case "share":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Progress shared successfully!")),
        );
        break;
      case "export":
        _showExportDialog(context, colors);
        break;
    }
  }

  void _showFullHistoryDialog(
      BuildContext context, AppColorsResolved colors, DashboardData data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Full Activity History", style: TextStyle(color: colors.blackColor)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.waterUpdates.length,
            itemBuilder: (context, index) {
              final update = data.waterUpdates[index];
              return ListTile(
                leading: Icon(Icons.water_drop, color: colors.primaryColor1),
                title: Text("Drank ${update.amount} Water"),
                subtitle: Text(update.time),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Close", style: TextStyle(color: colors.primaryColor1))),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Export Report", style: TextStyle(color: colors.blackColor)),
        content: const Text("Select export format:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Exported as PDF")));
            },
            child: const Text("PDF"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Exported as Excel")));
            },
            child: const Text("Excel"),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(
      AppColorsResolved colors, String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: colors.primaryColor1, fontSize: 12)),
      backgroundColor: colors.primaryColor2.withOpacity(0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      onPressed: onTap,
    );
  }

  void _showWaterGoalDialog(
      BuildContext context, AppColorsResolved colors, DashboardData data) {
    final controller = TextEditingController(text: data.waterGoal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Set Water Goal", style: TextStyle(color: colors.blackColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: colors.blackColor),
          decoration: const InputDecoration(labelText: "Liters"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context
                  .read<ActivityTrackerCubit>()
                  .updateGoals(waterGoal: double.tryParse(controller.text));
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showStepsGoalDialog(
      BuildContext context, AppColorsResolved colors, DashboardData data) {
    final controller = TextEditingController(text: data.stepsGoal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.whiteColor,
        title: Text("Set Steps Goal", style: TextStyle(color: colors.blackColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: colors.blackColor),
          decoration: const InputDecoration(labelText: "Steps"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context
                  .read<ActivityTrackerCubit>()
                  .updateGoals(stepsGoal: int.tryParse(controller.text));
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.bgColor,
      body: SafeArea(
        child: BlocBuilder<ActivityTrackerCubit, ActivityTrackerState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, colors, state.data),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TodayTargetSection(
                          data: state.data,
                          onAddTap: () => _showEditDialog(context, colors, state.data),
                          onWaterTap: () =>
                              _showWaterGoalDialog(context, colors, state.data),
                          onStepsTap: () =>
                              _showStepsGoalDialog(context, colors, state.data),
                        ),
                        const SizedBox(height: 30),
                        const ActivityProgressChart(),
                        const SizedBox(height: 30),
                        const LatestActivityList(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppColorsResolved colors, DashboardData data) {
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
            "Activity Tracker",
            style: AppTextStyles.heading1.copyWith(color: colors.blackColor),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMoreMenu(context, value, colors, data),
            itemBuilder: (context) => [
              const PopupMenuItem(value: "goals", child: Text("Daily Goal Settings")),
              const PopupMenuItem(value: "history", child: Text("View Full History")),
              const PopupMenuItem(value: "share", child: Text("Share Progress")),
              const PopupMenuItem(value: "export", child: Text("Export Report")),
            ],
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.grayColor3.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.more_horiz, color: colors.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}
