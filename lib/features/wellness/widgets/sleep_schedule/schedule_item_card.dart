// lib/features/wellness/widgets/sleep_schedule/schedule_item_card.dart
import 'package:flutter/material.dart';

class ScheduleItemCard extends StatelessWidget {
  const ScheduleItemCard({
    super.key,
    required this.entryKey,
    required this.emoji,
    required this.iconBg,
    required this.title,
    required this.time,
    required this.subtitle,
    required this.extraLine,
    required this.value,
    required this.onChanged,
    required this.onMenuAction,
  });

  final String entryKey;
  final String emoji;
  final Color iconBg;
  final String title;
  final String time;
  final String subtitle;
  final String extraLine;
  final bool value;
  final ValueChanged<bool> onChanged;
  final void Function(String entryKey, String title, String action)
      onMenuAction;

  static const Color accentPink = Color(0xFFDB99DF);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    Text(time,
                        style: const TextStyle(color: greyText, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: greyText, fontSize: 12)),
                const SizedBox(height: 2),
                Text(extraLine,
                    style: const TextStyle(color: greyText, fontSize: 10)),
              ],
            ),
          ),
          Switch(
              value: value, onChanged: onChanged, activeThumbColor: accentPink),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: greyText, size: 18),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (action) => onMenuAction(
                entryKey, title.replaceAll(',', '').trim(), action),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                  value: 'duplicate', child: Text('Duplicate to another day')),
              PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
    );
  }
}
