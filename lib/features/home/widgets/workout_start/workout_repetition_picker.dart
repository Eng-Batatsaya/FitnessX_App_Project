import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/workout_start_cubit.dart';

class WorkoutRepetitionPicker extends StatelessWidget {
  const WorkoutRepetitionPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<WorkoutStartCubit, WorkoutStartState>(
      builder: (context, state) {
        return SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(height: 1, color: colors.grayColor3.withOpacity(0.5)),
                  const SizedBox(height: 40),
                  Divider(height: 1, color: colors.grayColor3.withOpacity(0.5)),
                ],
              ),
              ListWheelScrollView.useDelegate(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                perspective: 0.005,
                diameterRatio: 1.5,
                onSelectedItemChanged: (index) {
                  context.read<WorkoutStartCubit>().updateRepetitions(index);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 100,
                  builder: (context, index) {
                    bool isCenter = index == state.repetitions;
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: isCenter ? Colors.red : colors.grayColor2.withOpacity(0.5),
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "450 Calories Burn",
                            style: TextStyle(
                              color: isCenter ? colors.grayColor1 : colors.grayColor2.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$index",
                            style: TextStyle(
                              color: isCenter ? colors.blackColor : colors.grayColor2.withOpacity(0.5),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isCenter)
                            Text(
                              " times",
                              style: TextStyle(color: colors.grayColor2, fontSize: 16),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
