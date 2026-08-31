// lib/features/wellness/widgets/compare_results/facing_photo_row.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';
import 'photo_tile.dart';

class FacingPhotoRow extends StatelessWidget {
  const FacingPhotoRow({
    super.key,
    required this.facing,
    required this.beforePhoto,
    required this.afterPhoto,
    required this.onOpenPhoto,
  });

  final PhotoFacing facing;
  final ProgressPhoto? beforePhoto;
  final ProgressPhoto? afterPhoto;
  final void Function(ProgressPhoto photo) onOpenPhoto;

  static const Color darkText = Color(0xFF1E1B2E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(facing.label,
                style: const TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700))),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PhotoTile(
                photo: beforePhoto,
                label: 'Before',
                onTap: () => onOpenPhoto(beforePhoto!),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PhotoTile(
                photo: afterPhoto,
                label: 'After',
                onTap: () => onOpenPhoto(afterPhoto!),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
