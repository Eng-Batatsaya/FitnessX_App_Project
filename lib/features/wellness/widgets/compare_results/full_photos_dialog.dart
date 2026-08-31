// lib/features/wellness/widgets/compare_results/full_photos_dialog.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

void openFullPhoto(BuildContext context, ProgressPhoto photo) {
  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.memory(photo.bytes, fit: BoxFit.contain)),
    ),
  );
}

void showOriginalPhotosGrid(BuildContext context, List<ProgressPhoto> photos) {
  if (photos.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('No photos to view yet')));
    return;
  }
  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 300,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final p = photos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  openFullPhoto(context, p);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(p.bytes, fit: BoxFit.cover)),
              );
            },
          ),
        ),
      ),
    ),
  );
}
