// lib/features/wellness/widgets/add_alarm/sleep_duration_sheet.dart
import 'package:flutter/material.dart';

Future<Duration?> showSleepDurationSheet(
    BuildContext context, Duration current) {
  int hours = current.inHours;
  int minutes = current.inMinutes % 60;

  return showModalBottomSheet<Duration>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Hours of sleep',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B2E))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Stepper(
                      label: 'Hours',
                      value: hours,
                      onDecrement: () =>
                          setSheetState(() => hours = (hours - 1).clamp(0, 12)),
                      onIncrement: () =>
                          setSheetState(() => hours = (hours + 1).clamp(0, 12)),
                    ),
                    _Stepper(
                      label: 'Minutes',
                      value: minutes,
                      onDecrement: () => setSheetState(() =>
                          minutes = (minutes - 15) < 0 ? 45 : minutes - 15),
                      onIncrement: () =>
                          setSheetState(() => minutes = (minutes + 15) % 60),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(sheetContext)
                        .pop(Duration(hours: hours, minutes: minutes)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF96B1FE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Done',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _Stepper extends StatelessWidget {
  const _Stepper(
      {required this.label,
      required this.value,
      required this.onDecrement,
      required this.onIncrement});
  final String label;
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF9C99AC), fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.remove_circle_outline,
                    color: Color(0xFF96B1FE)),
                onPressed: onDecrement),
            SizedBox(
              width: 36,
              child: Text('$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1B2E))),
            ),
            IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: Color(0xFF96B1FE)),
                onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}
