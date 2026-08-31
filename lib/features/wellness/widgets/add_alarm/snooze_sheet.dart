// lib/features/wellness/widgets/add_alarm/snooze_sheet.dart
import 'package:flutter/material.dart';

const List<int> kSnoozeOptions = [5, 10, 15, 20];

Future<int?> showSnoozeSheet(BuildContext context, int current) {
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
                child: Text('Snooze Duration',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B2E))),
              ),
            ),
            ...kSnoozeOptions.map((minutes) {
              final selected = minutes == current;
              return ListTile(
                title: Text('$minutes minutes',
                    style: TextStyle(
                        color: const Color(0xFF1E1B2E),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500)),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFF96B1FE))
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(minutes),
              );
            }),
          ],
        ),
      );
    },
  );
}
