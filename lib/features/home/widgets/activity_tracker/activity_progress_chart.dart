import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/activity_tracker_cubit.dart';
import '../../controllers/activity_tracker_state.dart';

class ActivityProgressChart extends StatelessWidget {
  const ActivityProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<ActivityTrackerCubit, ActivityTrackerState>(
      builder: (context, state) {
        final currentData = state.chartData[state.selectedRange]!;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Activity Progress",
                    style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      context.read<ActivityTrackerCubit>().updateRange(value),
                  itemBuilder: (context) => ["Daily", "Weekly", "Monthly"]
                      .map((range) => PopupMenuItem(
                            value: range,
                            child: Text(range,
                                style: TextStyle(color: colors.blackColor)),
                          ))
                      .toList(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: colors.primaryGradient),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(state.selectedRange,
                            style:
                                const TextStyle(color: Colors.white, fontSize: 12)),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: colors.blackColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar(colors, "Sun", currentData[0], colors.primaryColor1),
                  _buildBar(colors, "Mon", currentData[1], colors.secondaryColor1),
                  _buildBar(colors, "Tue", currentData[2], colors.primaryColor1),
                  _buildBar(colors, "Wed", currentData[3], colors.secondaryColor1),
                  _buildBar(colors, "Thu", currentData[4], colors.primaryColor1),
                  _buildBar(colors, "Fri", currentData[5], colors.secondaryColor1),
                  _buildBar(colors, "Sat", currentData[6], colors.primaryColor1),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBar(
      AppColorsResolved colors, String day, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 150,
          width: 22,
          decoration: BoxDecoration(
            color: colors.grayColor3.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150 * heightFactor,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.7),
                  color,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(color: colors.grayColor2, fontSize: 12)),
      ],
    );
  }
}
