// lib/features/wellness/screens/progress_photo.dart
import 'dart:typed_data';

/// The camera angle a progress photo was taken from.
enum PhotoFacing { front, back, left, right }

extension PhotoFacingX on PhotoFacing {
  String get label {
    switch (this) {
      case PhotoFacing.front:
        return 'Front Facing';
      case PhotoFacing.back:
        return 'Back Facing';
      case PhotoFacing.left:
        return 'Left Facing';
      case PhotoFacing.right:
        return 'Right Facing';
    }
  }

  String get shortLabel {
    switch (this) {
      case PhotoFacing.front:
        return 'Front';
      case PhotoFacing.back:
        return 'Back';
      case PhotoFacing.left:
        return 'Left';
      case PhotoFacing.right:
        return 'Right';
    }
  }
}

/// One real photo the user added, tagged with the angle it was taken from.
class ProgressPhoto {
  ProgressPhoto({required this.facing, required this.bytes});
  final PhotoFacing facing;
  final Uint8List bytes;
}

/// All photos (and optionally a body weight) captured on a single day.
/// This is the single source of truth shared by the Progress Photo screen
/// and both Compare Results screens.
class ProgressSession {
  ProgressSession(
      {required this.date, List<ProgressPhoto>? photos, this.weightKg})
      : photos = photos ?? [];

  final DateTime date;
  final List<ProgressPhoto> photos;
  double? weightKg;

  bool isSameDayAs(DateTime other) =>
      date.year == other.year &&
      date.month == other.month &&
      date.day == other.day;

  ProgressPhoto? photoFor(PhotoFacing facing) {
    for (final p in photos) {
      if (p.facing == facing) return p;
    }
    return null;
  }
}

/// Holds the "before" / "after" selection used to compare two sessions —
/// shared between CompareResultsScreen and CompareResultsDetailScreen so
/// switching tabs doesn't lose what the user picked.
class ComparisonState {
  ComparisonState({required this.sessions});

  final List<ProgressSession> sessions;

  ProgressSession? beforeSession;
  ProgressSession? afterSession;

  List<ProgressSession> get sortedSessions {
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  bool get hasEnoughData => sessions.length >= 2;

  void ensureDefaultSelection() {
    final sorted = sortedSessions;
    if (sorted.isEmpty) return;
    beforeSession ??= sorted.first;
    afterSession ??= sorted.last;
    if (beforeSession == afterSession && sorted.length > 1) {
      beforeSession = sorted.first;
      afterSession = sorted.last;
    }
  }

  /// How many of the 4 facing angles have a photo in BOTH sessions.
  int get matchedAngleCount {
    if (beforeSession == null || afterSession == null) return 0;
    var count = 0;
    for (final f in PhotoFacing.values) {
      if (beforeSession!.photoFor(f) != null &&
          afterSession!.photoFor(f) != null) {
        count++;
      }
    }
    return count;
  }

  /// Fraction (0..1) of facing angles matched — drives the progress bar.
  double get completeness => matchedAngleCount / PhotoFacing.values.length;

  double? get weightChangeKg {
    final before = beforeSession?.weightKg;
    final after = afterSession?.weightKg;
    if (before == null || after == null) return null;
    return after - before;
  }

  int get daysBetween {
    if (beforeSession == null || afterSession == null) return 0;
    return afterSession!.date.difference(beforeSession!.date).inDays.abs();
  }

  /// Every session that has a logged weight, sorted by date — feeds the
  /// weight trend chart on the Statistic tab.
  List<ProgressSession> get weightHistory {
    final withWeight = sessions.where((s) => s.weightKg != null).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return withWeight;
  }
}
