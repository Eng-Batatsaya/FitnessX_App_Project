import 'package:equatable/equatable.dart';
import '../../../core/models/dashboard_data.dart';

class ActivityTrackerState extends Equatable {
  final DashboardData data;
  final String selectedRange;
  final bool showAllActivities;
  final Map<String, List<double>> chartData;

  const ActivityTrackerState({
    required this.data,
    this.selectedRange = "Weekly",
    this.showAllActivities = false,
    this.chartData = const {},
  });

  ActivityTrackerState copyWith({
    DashboardData? data,
    String? selectedRange,
    bool? showAllActivities,
    Map<String, List<double>>? chartData,
  }) {
    return ActivityTrackerState(
      data: data ?? this.data,
      selectedRange: selectedRange ?? this.selectedRange,
      showAllActivities: showAllActivities ?? this.showAllActivities,
      chartData: chartData ?? this.chartData,
    );
  }

  @override
  List<Object?> get props => [data, selectedRange, showAllActivities, chartData];
}
