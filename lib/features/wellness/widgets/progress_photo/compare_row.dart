// lib/features/wellness/widgets/progress_photo/compare_row.dart
import 'package:flutter/material.dart';

class CompareRow extends StatelessWidget {
  const CompareRow({super.key, required this.onCompare});
  final VoidCallback onCompare;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color cardLavender = Color(0xFFEBF0FF);
  static const Color darkText = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
          color: cardLavender, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Expanded(
              child: Text('Compare my Photo',
                  style: TextStyle(
                      color: darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          ElevatedButton(
            onPressed: onCompare,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Compare',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
