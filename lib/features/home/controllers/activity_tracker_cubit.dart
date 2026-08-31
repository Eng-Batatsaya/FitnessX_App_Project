import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/dashboard_data.dart';
import 'activity_tracker_state.dart';

class ActivityTrackerCubit extends Cubit<ActivityTrackerState> {
  ActivityTrackerCubit(DashboardData? initialData)
      : super(ActivityTrackerState(
          data: initialData ?? DashboardData.initial(),
          chartData: const {
            "Weekly": [0.3, 0.7, 0.4, 0.6, 0.8, 0.3, 0.7],
            "Daily": [0.5, 0.4, 0.8, 0.7, 0.9, 0.6, 0.5],
            "Monthly": [0.7, 0.3, 0.6, 0.4, 0.5, 0.8, 0.6],
          },
        ));

  void updateRange(String range) {
    emit(state.copyWith(selectedRange: range));
  }

  void toggleShowAll() {
    emit(state.copyWith(showAllActivities: !state.showAllActivities));
  }

  void updateGoals({double? waterGoal, int? stepsGoal}) {
    emit(state.copyWith(
      data: state.data.copyWith(
        waterGoal: waterGoal,
        stepsGoal: stepsGoal,
      ),
    ));
  }
}
