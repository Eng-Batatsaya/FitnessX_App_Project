// lib/features/wellness/widgets/compare_results/back_home_button.dart
import 'package:flutter/material.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({super.key});

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPurple = Color(0xFF8C93F5);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [primaryBlue, accentPurple]),
              borderRadius: BorderRadius.circular(27)),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27)),
            ),
            child: const Text('Back to Home',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
