// lib/features/wellness/widgets/sleep_schedule/sleep_fab.dart
import 'package:flutter/material.dart';

class SleepFab extends StatelessWidget {
  const SleepFab({super.key, required this.onTap});
  final VoidCallback onTap;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPink = Color(0xFFDB99DF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [primaryBlue, accentPink]),
          boxShadow: [
            BoxShadow(
                color: accentPink.withValues(alpha: 0.5),
                blurRadius: 18,
                offset: const Offset(0, 8))
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
