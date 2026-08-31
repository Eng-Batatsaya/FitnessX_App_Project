import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../controllers/activity_tracker_cubit.dart';
import '../../controllers/activity_tracker_state.dart';
import 'activity_item.dart';

class LatestActivityList extends StatelessWidget {
  const LatestActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return BlocBuilder<ActivityTrackerCubit, ActivityTrackerState>(
      builder: (context, state) {
        final activitiesToShow = state.showAllActivities
            ? state.data.waterUpdates
            : state.data.waterUpdates.take(2).toList();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Latest Activity",
                    style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
                TextButton(
                  onPressed: () =>
                      context.read<ActivityTrackerCubit>().toggleShowAll(),
                  child: Text(
                    state.showAllActivities ? "See less" : "See more",
                    style: TextStyle(color: colors.grayColor2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...activitiesToShow.map((update) => Column(
                  children: [
                    ActivityItem(
                      title: "Drinking ${update.amount} Water",
                      time: update.time,
                      imageUrl: "https://via.placeholder.com/150",
                    ),
                    const SizedBox(height: 15),
                  ],
                )),
          ],
        );
      },
    );
  }
}
