// lib/features/wellness/widgets/progress_photo/session_row.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

class SessionRow extends StatelessWidget {
  const SessionRow({super.key, required this.session, required this.dateLabel});
  final ProgressSession session;
  final String dateLabel;

  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(dateLabel,
                  style: const TextStyle(color: greyText, fontSize: 13)),
              if (session.weightKg != null) ...[
                const SizedBox(width: 8),
                Text('• ${session.weightKg!.toStringAsFixed(1)} kg',
                    style: const TextStyle(color: greyText, fontSize: 12)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: session.photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final photo = session.photos[index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(photo.bytes,
                          width: 96, height: 96, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 4),
                    Text(photo.facing.shortLabel,
                        style: const TextStyle(color: greyText, fontSize: 10)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
