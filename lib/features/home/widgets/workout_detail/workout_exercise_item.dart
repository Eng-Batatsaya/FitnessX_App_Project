import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/workout_detail_cubit.dart';
import '../../screens/workout_start_screen.dart';

class WorkoutExerciseItem extends StatelessWidget {
  final String title;
  final String duration;
  final String imagePath;
  final bool isDone;

  const WorkoutExerciseItem({
    super.key,
    required this.title,
    required this.duration,
    required this.imagePath,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: () => context.read<WorkoutDetailCubit>().toggleExercise(title),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.green.withOpacity(0.1)
                        : colors.primaryColor2.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: isDone
                        ? Container(
                            color: Colors.green.withOpacity(0.3),
                            child: const Icon(Icons.check_circle,
                                color: Colors.green, size: 30),
                          )
                        : Image.asset(
                            imagePath,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(
                      color: isDone ? colors.grayColor2 : colors.blackColor,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(duration,
                      style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor2)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutStartScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.grayColor3),
                ),
                child: Icon(Icons.chevron_right, color: colors.grayColor2, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
