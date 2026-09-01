// lib/features/wellness/widgets/add_alarm/alarm_label_dialog.dart
import 'package:flutter/material.dart';

Future<String?> showAlarmLabelDialog(BuildContext context, String current) {
  final controller = TextEditingController(text: current);
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Alarm Label'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'e.g. Work Days'),
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
