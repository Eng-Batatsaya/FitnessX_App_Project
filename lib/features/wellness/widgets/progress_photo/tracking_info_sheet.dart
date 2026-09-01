// lib/features/wellness/widgets/progress_photo/tracking_info_sheet.dart
import 'package:flutter/material.dart';

void showTrackingInfoSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(10)),
            ),
            const Text('Why monthly progress photos?',
                style: TextStyle(
                    color: Color(0xFF1E1B2E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const Text(
              'The scale doesn\'t show muscle gain, posture changes, or fat '
              'redistribution — but photos taken from the same angle and '
              'lighting every month do. Comparing them side by side is '
              'often the clearest way to see real progress, especially '
              'when your weight barely moves.',
              style: TextStyle(
                  color: Color(0xFF9C99AC), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF96B1FE),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Got it',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
