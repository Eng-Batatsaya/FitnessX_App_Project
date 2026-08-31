import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import '../../../core/models/dashboard_data.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    loadData();
  }

  void loadData() {
    emit(HomeLoaded(DashboardData.initial()));
  }

  void addWater(double amountLiters) {
    if (state is HomeLoaded) {
      final currentData = (state as HomeLoaded).data;
      final newIntake = currentData.waterIntake + amountLiters;
      final now = DateTime.now();
      final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      
      final newUpdates = List<WaterUpdate>.from(currentData.waterUpdates);
      // Deactivate previous active update
      for (int i = 0; i < newUpdates.length; i++) {
        if (newUpdates[i].isActive) {
          newUpdates[i] = WaterUpdate(
            time: newUpdates[i].time,
            amount: newUpdates[i].amount,
            isActive: false,
          );
        }
      }
      
      newUpdates.add(WaterUpdate(
        time: "$timeStr - now",
        amount: "${(amountLiters * 1000).toInt()}ml",
        isActive: true,
      ));

      emit(HomeLoaded(currentData.copyWith(
        waterIntake: newIntake,
        waterUpdates: newUpdates,
        todayTargetProgress: min(1.0, currentData.todayTargetProgress + 0.05),
      )));
    }
  }

  void updateHeartRate() {
    if (state is HomeLoaded) {
      final currentData = (state as HomeLoaded).data;
      final random = Random();
      final newRate = 70 + random.nextInt(20); // 70-90
      final newPoints = List<double>.from(currentData.heartRatePoints);
      newPoints.removeAt(0);
      newPoints.add(0.3 + random.nextDouble() * 0.5);

      emit(HomeLoaded(currentData.copyWith(
        heartRate: newRate,
        heartRatePoints: newPoints,
        heartRateTimestamp: "Just now",
      )));
    }
  }

  void checkTodayTarget() {
    if (state is HomeLoaded) {
      final currentData = (state as HomeLoaded).data;
      emit(HomeLoaded(currentData.copyWith(
        todayTargetProgress: min(1.0, currentData.todayTargetProgress + 0.1),
      )));
    }
  }

  Future<void> refreshData() async {
    final currentData = (state is HomeLoaded) ? (state as HomeLoaded).data : DashboardData.initial();
    
    emit(HomeLoading());
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(HomeLoaded(currentData));
  }
}
