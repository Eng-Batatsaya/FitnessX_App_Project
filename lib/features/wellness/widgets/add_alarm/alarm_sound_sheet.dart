// lib/features/wellness/widgets/add_alarm/alarm_sound_sheet.dart
import 'package:flutter/material.dart';

const List<String> kAlarmSounds = [
  'Classic',
  'Chimes',
  'Digital',
  'Gentle Wake'
];

Future<String?> showAlarmSoundSheet(BuildContext context, String current) {
  return showModalBottomSheet<String>(
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
                child: Text('Alarm Sound',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B2E))),
              ),
            ),
            ...kAlarmSounds.map((sound) {
              final selected = sound == current;
              return ListTile(
                title: Text(sound,
                    style: TextStyle(
                        color: const Color(0xFF1E1B2E),
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500)),
                trailing: selected
                    ? const Icon(Icons.check, color: Color(0xFF96B1FE))
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(sound),
              );
            }),
          ],
        ),
      );
    },
  );
}
