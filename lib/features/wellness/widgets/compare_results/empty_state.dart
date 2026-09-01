// lib/features/wellness/widgets/compare_results/empty_state.dart
import 'package:flutter/material.dart';

class CompareEmptyState extends StatelessWidget {
  const CompareEmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.message,
      this.onBack});
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onBack;

  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);
  static const Color primaryBlue = Color(0xFF96B1FE);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: greyText, size: 40),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: greyText, fontSize: 13)),
            if (onBack != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Back to Progress Photo'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
