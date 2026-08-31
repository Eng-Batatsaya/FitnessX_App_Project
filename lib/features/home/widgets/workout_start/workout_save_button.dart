import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/workout_start_cubit.dart';

class WorkoutSaveButton extends StatelessWidget {
  const WorkoutSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<WorkoutStartCubit, WorkoutStartState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isSaving ? null : () => context.read<WorkoutStartCubit>().saveWorkout(),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.primaryGradient),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: state.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        );
      },
    );
  }
}
