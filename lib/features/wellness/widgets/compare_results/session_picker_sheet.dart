// lib/features/wellness/widgets/compare_results/session_picker_sheet.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

Future<ProgressSession?> showSessionPickerSheet(
  BuildContext context, {
  required List<ProgressSession> sessions,
  required bool isBefore,
  required String Function(DateTime) formatDate,
}) {
  return showModalBottomSheet<ProgressSession>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isBefore
                      ? 'Choose the "before" date'
                      : 'Choose the "after" date',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E1B2E)),
                ),
              ),
            ),
            ...sessions.map((s) => ListTile(
                  title: Text(formatDate(s.date)),
                  subtitle: Text(
                      '${s.photos.length} photo${s.photos.length == 1 ? '' : 's'}'),
                  onTap: () => Navigator.of(sheetContext).pop(s),
                )),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
