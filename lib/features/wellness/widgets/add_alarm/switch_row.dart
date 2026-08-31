// lib/features/wellness/widgets/add_alarm/switch_row.dart
import 'package:flutter/material.dart';

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  static const Color darkText = Color(0xFF1E1B2E);
  static const Color accentPink = Color(0xFFDB99DF);
  static const Color rowBg = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration:
          BoxDecoration(color: rowBg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: darkText, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
          Switch(
              value: value, onChanged: onChanged, activeThumbColor: accentPink),
        ],
      ),
    );
  }
}
