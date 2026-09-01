// lib/features/wellness/widgets/progress_photo/weight_prompt_dialog.dart
import 'package:flutter/material.dart';

Future<double?> showWeightPromptDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<double>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Log your weight? (optional)'),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration:
            const InputDecoration(hintText: 'e.g. 78.5', suffixText: 'kg'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Skip')),
        TextButton(
          onPressed: () {
            final v = double.tryParse(controller.text.trim());
            Navigator.of(dialogContext).pop(v);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
