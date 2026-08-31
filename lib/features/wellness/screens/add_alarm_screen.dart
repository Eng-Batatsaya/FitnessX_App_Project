// lib/features/wellness/screens/add_alarm_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/add_alarm_cubit.dart';
import '../controllers/add_alarm_state.dart';
import '../widgets/add_alarm/settings_row.dart';
import '../widgets/add_alarm/switch_row.dart';
import '../widgets/add_alarm/alarm_sound_sheet.dart';
import '../widgets/add_alarm/snooze_sheet.dart';
import '../widgets/add_alarm/repeat_sheet.dart';
import '../widgets/add_alarm/alarm_label_dialog.dart';
import '../widgets/add_alarm/delete_alarm_dialog.dart';
import '../widgets/add_alarm/sleep_duration_sheet.dart';

class AddAlarmScreen extends StatelessWidget {
  const AddAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAlarmCubit(),
      child: const _AddAlarmView(),
    );
  }
}

class _AddAlarmView extends StatelessWidget {
  const _AddAlarmView();

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPink = Color(0xFFDB99DF);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color rowBg = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: darkText),
        title: const Text('Add Alarm',
            style: TextStyle(
                color: darkText, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [_buildScreenMenu(context)],
      ),
      body: BlocBuilder<AddAlarmCubit, AddAlarmState>(
        builder: (context, state) {
          final cubit = context.read<AddAlarmCubit>();
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      if (state.alarmLabel.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 4),
                            child: Text('Label: ${state.alarmLabel}',
                                style: const TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                          ),
                        ),
                      SettingsRow(
                        icon: Icons.bed,
                        label: 'Bedtime',
                        value: cubit.formatTime(state.bedtime),
                        onTap: () async {
                          final picked = await showTimePicker(
                              context: context,
                              initialTime: state.bedtime,
                              helpText: 'Set bedtime');
                          if (picked != null) cubit.setBedtime(picked);
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsRow(
                        icon: Icons.access_time,
                        label: 'Hours of sleep',
                        value: cubit.formatDuration(state.sleepDuration),
                        onTap: () async {
                          final result = await showSleepDurationSheet(
                              context, state.sleepDuration);
                          if (result != null) cubit.setSleepDuration(result);
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsRow(
                        icon: Icons.repeat,
                        label: 'Repeat',
                        value: state.repeatLabel,
                        onTap: () async {
                          final result =
                              await showRepeatSheet(context, state.repeatLabel);
                          if (result != null) cubit.setRepeat(result);
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchRow(
                        icon: Icons.vibration,
                        label: 'vibrate When Alarm Sound',
                        value: state.vibrateEnabled,
                        onChanged: cubit.toggleVibrate,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [primaryBlue, accentPink]),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                            color: accentPink.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(cubit.buildResult()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('Add',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScreenMenu(BuildContext context) {
    return BlocBuilder<AddAlarmCubit, AddAlarmState>(
      builder: (context, state) {
        final cubit = context.read<AddAlarmCubit>();
        return Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
              color: rowBg, borderRadius: BorderRadius.circular(12)),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: darkText, size: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (value) async {
              switch (value) {
                case 'sound':
                  final result =
                      await showAlarmSoundSheet(context, state.alarmSound);
                  if (result != null) cubit.setAlarmSound(result);
                  break;
                case 'snooze':
                  final result =
                      await showSnoozeSheet(context, state.snoozeMinutes);
                  if (result != null) cubit.setSnooze(result);
                  break;
                case 'label':
                  final result =
                      await showAlarmLabelDialog(context, state.alarmLabel);
                  if (result != null) cubit.setAlarmLabel(result);
                  break;
                case 'delete':
                  final confirmed = await showDeleteAlarmDialog(context);
                  if (!context.mounted) break;
                  if (confirmed == true) {
                    Navigator.of(context).pop();
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'sound',
                  child: Text('Alarm Sound  ·  ${state.alarmSound}')),
              PopupMenuItem(
                  value: 'snooze',
                  child: Text('Snooze  ·  ${state.snoozeMinutes} min')),
              const PopupMenuItem(value: 'label', child: Text('Set Label')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Alarm',
                      style: TextStyle(color: Colors.red))),
            ],
          ),
        );
      },
    );
  }
}
