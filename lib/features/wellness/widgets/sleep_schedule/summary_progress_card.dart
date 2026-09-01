// lib/features/wellness/widgets/sleep_schedule/summary_progress_card.dart
import 'package:flutter/material.dart';

class SummaryProgressCard extends StatelessWidget {
  const SummaryProgressCard(
      {super.key, required this.durationLabel, required this.percent});

  final String durationLabel;
  final double percent;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPink = Color(0xFFDB99DF);
  static const Color summaryBg = Color(0xFFF8EAF9);
  static const Color darkText = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: summaryBg, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You will get $durationLabel\nfor tonight.',
              style: const TextStyle(
                  color: darkText, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final fillWidth = constraints.maxWidth * clamped;
              return SizedBox(
                height: 22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 10,
                        width: fillWidth,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [primaryBlue, accentPink]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      '${(clamped * 100).round()}%',
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 4),
                          Shadow(color: Colors.white, blurRadius: 4)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
