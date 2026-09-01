// lib/features/wellness/widgets/progress_photo/gallery_header.dart
import 'package:flutter/material.dart';

class GalleryHeader extends StatelessWidget {
  const GalleryHeader(
      {super.key,
      required this.hasSessions,
      required this.isPicking,
      required this.onAddPhoto});
  final bool hasSessions;
  final bool isPicking;
  final VoidCallback onAddPhoto;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPink = Color(0xFFDB99DF);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gallery',
                  style: TextStyle(
                      color: darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(hasSessions ? 'See more' : 'No photos yet',
                  style: const TextStyle(color: greyText, fontSize: 12)),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isPicking ? null : onAddPhoto,
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [primaryBlue, accentPink])),
            child: isPicking
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.photo_camera, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}
