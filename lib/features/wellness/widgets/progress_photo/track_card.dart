// lib/features/wellness/widgets/progress_photo/track_card.dart
import 'package:flutter/material.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({super.key, required this.onLearnMore});
  final VoidCallback onLearnMore;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color cardLavender = Color(0xFFEBF0FF);
  static const Color darkText = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: cardLavender, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                        color: darkText,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.3),
                    children: [
                      TextSpan(text: 'Track Your Progress Each Month With '),
                      TextSpan(
                          text: 'Photo', style: TextStyle(color: primaryBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onLearnMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                  ),
                  child: const Text('Learn More',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const _CalendarIllustration(),
        ],
      ),
    );
  }
}

class _CalendarIllustration extends StatelessWidget {
  const _CalendarIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (i) {
                final marks = {
                  2: Colors.red,
                  5: TrackCard.primaryBlue,
                  7: Colors.red
                };
                return Container(
                    decoration: BoxDecoration(
                        color: marks[i] ?? const Color(0xFFEFEFF5),
                        borderRadius: BorderRadius.circular(3)));
              }),
            ),
          ),
          const Positioned(
            bottom: -6,
            right: -6,
            child: CircleAvatar(
                radius: 14,
                backgroundColor: TrackCard.primaryBlue,
                child: Icon(Icons.photo_camera, color: Colors.white, size: 14)),
          ),
        ],
      ),
    );
  }
}
