import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/workout_start_cubit.dart';
import '../widgets/workout_start/workout_repetition_picker.dart';
import '../widgets/workout_start/workout_save_button.dart';
import '../widgets/workout_start/workout_steps_list.dart';
import '../widgets/workout_start/workout_video_header.dart';

class WorkoutStartScreen extends StatelessWidget {
  const WorkoutStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutStartCubit(),
      child: const WorkoutStartView(),
    );
  }
}

class WorkoutStartView extends StatelessWidget {
  const WorkoutStartView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WorkoutVideoHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jumping Jack",
                      style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
                  const SizedBox(height: 5),
                  Text("Easy | 390 Calories Burn",
                      style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
                  const SizedBox(height: 30),
                  Text("Descriptions",
                      style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text:
                          "A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide ",
                      style: AppTextStyles.bodyMedium.copyWith(color: colors.grayColor1),
                      children: [
                        TextSpan(
                          text: "Read More...",
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.primaryColor1, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("How To Do It",
                          style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                      Text("4 Steps",
                          style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WorkoutStepsList(),
                  const SizedBox(height: 30),
                  Text("Custom Repetitions",
                      style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                  const SizedBox(height: 20),
                  const WorkoutRepetitionPicker(),
                  const SizedBox(height: 30),
                  const WorkoutSaveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
