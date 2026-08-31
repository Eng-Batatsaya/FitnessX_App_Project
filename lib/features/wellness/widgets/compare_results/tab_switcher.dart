// lib/features/wellness/widgets/compare_results/tab_switcher.dart
import 'package:flutter/material.dart';

class TabSwitcher extends StatelessWidget {
  const TabSwitcher(
      {super.key,
      required this.photoActive,
      required this.onTapPhoto,
      required this.onTapStatistic});
  final bool photoActive;
  final VoidCallback onTapPhoto;
  final VoidCallback onTapStatistic;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPurple = Color(0xFF8C93F5);
  static const Color cardLavender = Color(0xFFEBF0FF);
  static const Color rowBg = Color(0xFFF4F5F7);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: photoActive ? cardLavender : rowBg,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(child: _tab('Photo', photoActive, onTapPhoto)),
          Expanded(child: _tab('Statistic', !photoActive, onTapStatistic)),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: active ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: active
            ? BoxDecoration(
                gradient:
                    const LinearGradient(colors: [primaryBlue, accentPurple]),
                borderRadius: BorderRadius.circular(16))
            : null,
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : greyText,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                fontSize: 14)),
      ),
    );
  }
}
