// lib/features/wellness/widgets/progress_photo/facing_picker_sheet.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

Future<PhotoFacing?> showFacingPickerSheet(BuildContext context) {
  return showModalBottomSheet<PhotoFacing>(
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
                child: Text('Which angle is this photo?',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1B2E))),
              ),
            ),
            ...PhotoFacing.values.map((f) => ListTile(
                  leading: const Icon(Icons.accessibility_new,
                      color: Color(0xFF96B1FE)),
                  title: Text(f.label),
                  onTap: () => Navigator.of(sheetContext).pop(f),
                )),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
