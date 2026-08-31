import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/notification_cubit.dart';
import '../controllers/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(),
      child: const NotificationView(),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, colors),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: colors.grayColor3.withOpacity(0.5)),
                    ),
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];
                      return _buildNotificationItem(context, item, index, colors);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsResolved colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.grayColor3.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.chevron_left, color: colors.blackColor),
            ),
          ),
          Text(
            "Notification",
            style: AppTextStyles.heading1.copyWith(color: colors.blackColor),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.grayColor3.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.more_horiz, color: colors.blackColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel item, int index, AppColorsResolved colors) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: item.iconBgColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(item.icon, color: item.iconColor, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.heading3.copyWith(fontSize: 12, color: colors.blackColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                item.time,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: colors.grayColor2),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Show menu to remove notification
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 0), // Placeholder position
              items: [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ).then((value) {
              if (value == 'delete') {
                context.read<NotificationCubit>().removeNotification(index);
              }
            });
          },
          icon: Icon(Icons.more_vert, color: colors.grayColor1, size: 20),
        ),
      ],
    );
  }
}
