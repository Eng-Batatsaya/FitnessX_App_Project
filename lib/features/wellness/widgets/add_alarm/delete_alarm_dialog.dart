// lib/features/wellness/widgets/add_alarm/delete_alarm_dialog.dart
import 'package:flutter/material.dart';

Future<bool?> showDeleteAlarmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete this alarm?'),
      content: const Text('This closes the screen without saving any changes.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
