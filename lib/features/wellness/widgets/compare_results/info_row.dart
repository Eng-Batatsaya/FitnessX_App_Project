// lib/features/wellness/widgets/compare_results/info_row.dart
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow(
      {super.key, required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  static const Color rowBg = Color(0xFFF4F5F7);
  static const Color darkText = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration:
          BoxDecoration(color: rowBg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: darkText, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
