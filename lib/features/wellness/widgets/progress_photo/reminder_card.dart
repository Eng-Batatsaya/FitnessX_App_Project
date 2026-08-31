// lib/features/wellness/widgets/progress_photo/reminder_card.dart
import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard(
      {super.key,
      required this.nextDateLabel,
      required this.dayNumber,
      required this.onClose});
  final String nextDateLabel;
  final int dayNumber;
  final VoidCallback onClose;

  static const Color reminderBg = Color(0xFFFCE7E7);
  static const Color reminderRed = Color(0xFFE85C5C);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: reminderBg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Icon(dayNumber: dayNumber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reminder!',
                    style: TextStyle(
                        color: reminderRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text('Next Photos Fall On $nextDateLabel',
                    style: const TextStyle(
                        color: darkText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, color: greyText, size: 18)),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.dayNumber});
  final int dayNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('$dayNumber',
                style: const TextStyle(
                    color: ReminderCard.darkText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: ReminderCard.reminderRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.alarm, color: Colors.white, size: 11),
            ),
          ),
        ],
      ),
    );
  }
}
