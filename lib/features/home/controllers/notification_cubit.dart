import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    final notifications = [
      NotificationModel(
        title: "Hey, it's time for lunch",
        time: "About 1 minutes ago",
        icon: Icons.restaurant,
        iconColor: Colors.orange,
        iconBgColor: Colors.orange.withOpacity(0.1),
      ),
      NotificationModel(
        title: "Don't miss your lowerbody workout",
        time: "About 3 hours ago",
        icon: Icons.fitness_center,
        iconColor: AppColors.secondaryColor1,
        iconBgColor: AppColors.secondaryColor1.withOpacity(0.1),
      ),
      NotificationModel(
        title: "Hey, let's add some meals for your b..",
        time: "About 3 hours ago",
        icon: Icons.lunch_dining,
        iconColor: Colors.amber,
        iconBgColor: Colors.amber.withOpacity(0.1),
      ),
      NotificationModel(
        title: "Congratulations, You have finished A..",
        time: "29 May",
        icon: Icons.person,
        iconColor: AppColors.primaryColor1,
        iconBgColor: AppColors.primaryColor1.withOpacity(0.1),
      ),
      NotificationModel(
        title: "Hey, it's time for lunch",
        time: "8 April",
        icon: Icons.restaurant,
        iconColor: Colors.orange,
        iconBgColor: Colors.orange.withOpacity(0.1),
      ),
      NotificationModel(
        title: "Ups, You have missed your Lowerbo...",
        time: "3 April",
        icon: Icons.fitness_center,
        iconColor: AppColors.secondaryColor1,
        iconBgColor: AppColors.secondaryColor1.withOpacity(0.1),
      ),
    ];
    emit(NotificationState(notifications: notifications));
  }

  void removeNotification(int index) {
    final updatedList = List<NotificationModel>.from(state.notifications);
    updatedList.removeAt(index);
    emit(NotificationState(notifications: updatedList));
  }
}
