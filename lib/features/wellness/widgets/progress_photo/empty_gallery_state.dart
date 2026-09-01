// lib/features/wellness/widgets/progress_photo/empty_gallery_state.dart
import 'package:flutter/material.dart';

class EmptyGalleryState extends StatelessWidget {
  const EmptyGalleryState({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3E4EA))),
        child: const Column(
          children: [
            Icon(Icons.add_a_photo_outlined,
                color: Color(0xFF9C99AC), size: 30),
            SizedBox(height: 10),
            Text('No progress photos yet',
                style: TextStyle(
                    color: Color(0xFF1E1B2E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Tap here or the camera button to add your first one',
                style: TextStyle(color: Color(0xFF9C99AC), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
