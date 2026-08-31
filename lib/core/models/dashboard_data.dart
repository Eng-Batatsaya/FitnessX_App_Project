import 'package:equatable/equatable.dart';

class DashboardData extends Equatable {
  final double waterIntake; // in Liters
  final double waterGoal; // in Liters
  final List<WaterUpdate> waterUpdates;
  final int heartRate;
  final String heartRateTimestamp;
  final List<double> heartRatePoints;
  final String sleepDuration; // e.g., "8h 20m"
  final double sleepQuality; // 0.0 to 1.0
  final int caloriesBurned;
  final int caloriesGoal;
  final int steps;
  final int stepsGoal;
  final double todayTargetProgress;

  const DashboardData({
    required this.waterIntake,
    required this.waterGoal,
    required this.waterUpdates,
    required this.heartRate,
    required this.heartRateTimestamp,
    required this.heartRatePoints,
    required this.sleepDuration,
    required this.sleepQuality,
    required this.caloriesBurned,
    required this.caloriesGoal,
    required this.steps,
    required this.stepsGoal,
    required this.todayTargetProgress,
  });

  factory DashboardData.initial() {
    return DashboardData(
      waterIntake: 4.0,
      waterGoal: 8.0,
      waterUpdates: const [
        WaterUpdate(time: "6am - 8am", amount: "600ml"),
        WaterUpdate(time: "9am - 11am", amount: "500ml"),
        WaterUpdate(time: "11am - 2pm", amount: "1000ml"),
        WaterUpdate(time: "2pm - 4pm", amount: "700ml"),
        WaterUpdate(time: "4pm - now", amount: "900ml", isActive: true),
      ],
      heartRate: 78,
      heartRateTimestamp: "3mins ago",
      heartRatePoints: const [0.7, 0.65, 0.75, 0.5, 0.8, 0.4, 0.6, 0.3, 0.7, 0.5, 0.6],
      sleepDuration: "8h 20m",
      sleepQuality: 0.8,
      caloriesBurned: 760,
      caloriesGoal: 1000,
      steps: 2400,
      stepsGoal: 5000,
      todayTargetProgress: 0.5,
    );
  }

  DashboardData copyWith({
    double? waterIntake,
    double? waterGoal,
    List<WaterUpdate>? waterUpdates,
    int? heartRate,
    String? heartRateTimestamp,
    List<double>? heartRatePoints,
    String? sleepDuration,
    double? sleepQuality,
    int? caloriesBurned,
    int? caloriesGoal,
    int? steps,
    int? stepsGoal,
    double? todayTargetProgress,
  }) {
    return DashboardData(
      waterIntake: waterIntake ?? this.waterIntake,
      waterGoal: waterGoal ?? this.waterGoal,
      waterUpdates: waterUpdates ?? this.waterUpdates,
      heartRate: heartRate ?? this.heartRate,
      heartRateTimestamp: heartRateTimestamp ?? this.heartRateTimestamp,
      heartRatePoints: heartRatePoints ?? this.heartRatePoints,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      todayTargetProgress: todayTargetProgress ?? this.todayTargetProgress,
    );
  }

  @override
  List<Object?> get props => [
        waterIntake,
        waterGoal,
        waterUpdates,
        heartRate,
        heartRateTimestamp,
        heartRatePoints,
        sleepDuration,
        sleepQuality,
        caloriesBurned,
        caloriesGoal,
        steps,
        stepsGoal,
        todayTargetProgress,
      ];
}

class WaterUpdate extends Equatable {
  final String time;
  final String amount;
  final bool isActive;

  const WaterUpdate({
    required this.time,
    required this.amount,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [time, amount, isActive];
}
