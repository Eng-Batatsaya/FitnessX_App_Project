// lib/features/wellness/widgets/progress_photo/reminder_frequency_sheet.dart
import 'package:flutter/material.dart';

const List<int> kReminderFrequencyOptions = [7, 14, 30, 60];

Future<int?> showReminderFrequencySheet(BuildContext context, int current) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Remind me every…',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B2E))),
              ),
            ),
            ...kReminderFrequencyOptions.map((days) {
              final selected = days == current;
              return ListTile(
                title: Text('$days days',
                    style: TextStyle(
                        color: const Color(0xFF1E1B2E),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500)),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFF96B1FE))
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(days),
              );
            }),
          ],
        ),
      );
    },
  );
}
