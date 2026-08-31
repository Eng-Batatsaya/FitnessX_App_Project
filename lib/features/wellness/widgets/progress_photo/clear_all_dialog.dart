// lib/features/wellness/widgets/progress_photo/clear_all_dialog.dart
import 'package:flutter/material.dart';

Future<bool?> showClearAllDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Clear all photos?'),
      content:
          const Text('This removes every progress photo from the gallery.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red))),
      ],
    ),
  );
}
