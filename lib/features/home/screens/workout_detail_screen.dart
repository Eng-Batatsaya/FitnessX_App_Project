import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'workout_start_screen.dart';
import '../controllers/workout_detail_cubit.dart';
import '../controllers/workout_detail_state.dart';
import '../widgets/workout_detail/workout_detail_header.dart';
import '../widgets/workout_detail/workout_exercise_item.dart';
import '../widgets/workout_detail/workout_info_row.dart';
import '../widgets/workout_detail/workout_need_item.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutDetailCubit(),
      child: const WorkoutDetailView(),
    );
  }
}

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({super.key});

  final List<String> _difficulties = const ["Beginner", "Intermediate", "Advanced"];

  Future<void> _selectDateTime(BuildContext context, WorkoutDetailState state,
      AppColorsResolved colors) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: state.selectedDateTime.isBefore(DateTime.now())
          ? DateTime.now()
          : state.selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(state.selectedDateTime),
      );

      if (pickedTime != null) {
        context.read<WorkoutDetailCubit>().updateDateTime(DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ));
      }
    }
  }

  void _selectDifficulty(BuildContext context, AppColorsResolved colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Difficulty",
                  style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
              const SizedBox(height: 20),
              ..._difficulties.map((diff) => ListTile(
                    title: Text(diff,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.blackColor)),
                    onTap: () {
                      context.read<WorkoutDetailCubit>().updateDifficulty(diff);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    final month = dt.month;
    final day = dt.day;
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? "PM" : "AM";
    return "$month/$day, ${hour.toString().padLeft(2, '0')}:$minute $period";
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
              _buildMenuItem(colors, Icons.share_outlined, "Share Workout", () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Workout shared successfully!")),
                );
              }),
              _buildMenuItem(colors, Icons.calendar_month_outlined, "Add to My Calendar",
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Workout added to your calendar!")),
                );
              }),
              _buildMenuItem(colors, Icons.info_outline, "Workout Description", () {
                Navigator.pop(context);
                _showWorkoutDescription(context, colors);
              }),
              _buildMenuItem(colors, Icons.star_outline, "Rate this Workout", () {
                Navigator.pop(context);
                _showRatingDialog(context, colors);
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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

  void _showWorkoutDescription(BuildContext context, AppColorsResolved colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fullbody Workout",
            style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        content: Text(
          "This fullbody workout is designed to help you burn fat and build muscle. It includes a variety of exercises targeting all major muscle groups. Stay hydrated and follow the set instructions for best results.",
          style: AppTextStyles.bodyMedium.copyWith(color: colors.grayColor1),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: colors.primaryColor1)),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, AppColorsResolved colors) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Center(
              child: Text("Rate Workout",
                  style: AppTextStyles.heading2.copyWith(color: colors.blackColor))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("How was your workout session?"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel", style: TextStyle(color: colors.grayColor2)),
            ),
            ElevatedButton(
              onPressed: rating == 0
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Thank you for rating us $rating stars!")),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primaryColor1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: BlocBuilder<WorkoutDetailCubit, WorkoutDetailState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const WorkoutDetailHeader(),
                    _buildContent(context, colors, state),
                  ],
                ),
              ),
              _buildTopButtons(context, colors),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context, AppColorsResolved colors) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.whiteColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.chevron_left, color: colors.blackColor, size: 20),
              ),
            ),
            GestureDetector(
              onTap: () => _showMoreMenu(context, colors),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.whiteColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.more_horiz, color: colors.blackColor, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, AppColorsResolved colors, WorkoutDetailState state) {
    return Container(
      width: double.infinity,
      transform: Matrix4.translationValues(0, -40, 0),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fullbody Workout",
                      style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
                  const SizedBox(height: 5),
                  Text(
                    "11 Exercises | 32mins | 320 Calories Burn",
                    style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor1),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.read<WorkoutDetailCubit>().toggleFavorite(),
                child: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          WorkoutInfoRow(
            icon: Icons.calendar_month_outlined,
            title: "Schedule Workout",
            value: _formatDateTime(state.selectedDateTime),
            onTap: () => _selectDateTime(context, state, colors),
          ),
          const SizedBox(height: 15),
          WorkoutInfoRow(
            icon: Icons.swap_vert_rounded,
            title: "Difficulty",
            value: state.selectedDifficulty,
            color: colors.secondaryColor2.withOpacity(0.1),
            onTap: () => _selectDifficulty(context, colors),
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("You’ll Need", "5 Items", colors),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                WorkoutNeedItem(
                  label: "Barbell",
                  imagePath: "lib/features/home/assets/images/barbel.png",
                  isSelected: state.selectedNeeds.contains("Barbell"),
                  onTap: () => context.read<WorkoutDetailCubit>().toggleNeed("Barbell"),
                ),
                WorkoutNeedItem(
                  label: "Skipping Rope",
                  imagePath: "lib/features/home/assets/images/Skipping Rope.png",
                  isSelected: state.selectedNeeds.contains("Skipping Rope"),
                  onTap: () =>
                      context.read<WorkoutDetailCubit>().toggleNeed("Skipping Rope"),
                ),
                WorkoutNeedItem(
                  label: "Bottle 1 Liters",
                  imagePath: "lib/features/home/assets/images/Bottle 1 Liters (2).png",
                  isSelected: state.selectedNeeds.contains("Bottle 1 L"),
                  onTap: () =>
                      context.read<WorkoutDetailCubit>().toggleNeed("Bottle 1 L"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildSectionHeader("Exercises", "3 Sets", colors),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Set 1",
                  style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkoutStartScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.primaryGradient),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Start Workout",
                    style: TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          WorkoutExerciseItem(
              title: "Warm Up",
              duration: "05:00",
              imagePath: "lib/features/home/assets/images/Vector-Exercises.png",
              isDone: state.completedExercises.contains("Warm Up")),
          WorkoutExerciseItem(
              title: "Jumping Jack",
              duration: "12x",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (1).png",
              isDone: state.completedExercises.contains("Jumping Jack")),
          WorkoutExerciseItem(
              title: "Skipping",
              duration: "15x",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (2).png",
              isDone: state.completedExercises.contains("Skipping")),
          WorkoutExerciseItem(
              title: "Squats",
              duration: "20x",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (3).png",
              isDone: state.completedExercises.contains("Squats")),
          WorkoutExerciseItem(
              title: "Arm Raises",
              duration: "00:53",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (4).png",
              isDone: state.completedExercises.contains("Arm Raises")),
          WorkoutExerciseItem(
              title: "Rest and Drink",
              duration: "02:00",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (5).png",
              isDone: state.completedExercises.contains("Rest and Drink")),
          const SizedBox(height: 20),
          Text("Set 2",
              style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
          const SizedBox(height: 15),
          WorkoutExerciseItem(
              title: "Incline Push-Ups",
              duration: "12x",
              imagePath: "lib/features/home/assets/images/Vector (2).png",
              isDone: state.completedExercises.contains("Incline Push-Ups")),
          WorkoutExerciseItem(
              title: "Push-Ups",
              duration: "15x",
              imagePath: "lib/features/home/assets/images/Vector (3).png",
              isDone: state.completedExercises.contains("Push-Ups")),
          WorkoutExerciseItem(
              title: "Skipping",
              duration: "15x",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (2).png",
              isDone: state.completedExercises.contains("Skipping")),
          WorkoutExerciseItem(
              title: "Cobra Stretch",
              duration: "20x",
              imagePath: "lib/features/home/assets/images/Vector-Exercises (6).png",
              isDone: state.completedExercises.contains("Cobra Stretch")),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, AppColorsResolved colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
        Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
      ],
    );
  }
}
