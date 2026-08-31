// lib/features/wellness/widgets/compare_results/photo_tile.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile(
      {super.key,
      required this.photo,
      required this.label,
      required this.onTap});
  final ProgressPhoto? photo;
  final String label;
  final VoidCallback onTap;

  static const Color rowBg = Color(0xFFF4F5F7);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: photo == null ? null : onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
              color: rowBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE3E4EA))),
          child: photo == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image_outlined, color: greyText, size: 26),
                    const SizedBox(height: 4),
                    Text('No $label photo',
                        style: const TextStyle(color: greyText, fontSize: 10)),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(photo!.bytes, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
