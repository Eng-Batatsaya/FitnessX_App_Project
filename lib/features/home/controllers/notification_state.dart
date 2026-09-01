import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NotificationModel extends Equatable {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const NotificationModel({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  List<Object?> get props => [title, time, icon, iconColor, iconBgColor];
}

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;

  const NotificationState({this.notifications = const []});

  @override
  List<Object?> get props => [notifications];
}
