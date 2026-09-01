import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/workout_tracker_cubit.dart';
import '../../controllers/workout_tracker_state.dart';
import 'workout_wave_painter.dart';

class WorkoutTrackerChart extends StatelessWidget {
  const WorkoutTrackerChart({super.key});

  static const List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<WorkoutTrackerCubit, WorkoutTrackerState>(
      builder: (context, state) {
        if (state.dayDetails.isEmpty) return const SizedBox.shrink();

        final selectedDayData = state.dayDetails[state.selectedDayIndex]!;
        final screenWidth = MediaQuery.of(context).size.width;
        final chartWidth = screenWidth - 80;

        return Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  6,
                                  (index) => Divider(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                left: (chartWidth / 6) * state.selectedDayIndex - 17.5,
                                bottom: 0,
                                top: 20,
                                child: Container(
                                  width: 35,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.3),
                                        Colors.white.withOpacity(0.0)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: WorkoutWavePainter(
                                    color: Colors.white,
                                    primaryColor: colors.primaryColor1,
                                    selectedIndex: state.selectedDayIndex,
                                  ),
                                ),
                              ),
                              Row(
                                children: List.generate(7, (index) {
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => context
                                          .read<WorkoutTrackerCubit>()
                                          .selectDay(index),
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ["100%", "80%", "60%", "40%", "20%", "0%"]
                              .map((label) => Text(
                                    label,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _days.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String day = entry.value;
                      bool isSelected = idx == state.selectedDayIndex;
                      return GestureDetector(
                        onTap: () =>
                            context.read<WorkoutTrackerCubit>().selectDay(idx),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 5,
                left: (chartWidth / 6) * state.selectedDayIndex - 50,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: colors.blackColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${_days[state.selectedDayIndex]}, ${selectedDayData.date}",
                              style:
                                  TextStyle(fontSize: 8, color: colors.grayColor2)),
                          const SizedBox(width: 15),
                          Text("${selectedDayData.percent}% ↑",
                              style: const TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF42D08B),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(selectedDayData.workout,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colors.blackColor)),
                      const SizedBox(height: 6),
                      Container(
                        width: 100,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.grayColor3.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: selectedDayData.percent.toDouble(),
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: colors.primaryGradient),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
