// lib/features/wellness/widgets/add_alarm/settings_row.dart
import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);
  static const Color rowBg = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: rowBg, borderRadius: BorderRadius.circular(16)),
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
            Text(value, style: const TextStyle(color: greyText, fontSize: 12)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: greyText, size: 20),
          ],
        ),
      ),
    );
  }
}
