// lib/features/wellness/controllers/progress_photo_state.dart
import 'package:equatable/equatable.dart';
import '../screens/progress_photo.dart';

class ProgressPhotoState extends Equatable {
  const ProgressPhotoState({
    this.sessions = const [],
    this.reminderEnabled = true,
    this.reminderFrequencyDays = 30,
    this.isPicking = false,
  });

  final List<ProgressSession> sessions;
  final bool reminderEnabled;
  final int reminderFrequencyDays;
  final bool isPicking;

  DateTime get nextReminderDate {
    final base = sessions.isEmpty ? DateTime.now() : sessions.first.date;
    return base.add(Duration(days: reminderFrequencyDays));
  }

  ProgressSession? sessionForDate(DateTime d) {
    for (final s in sessions) {
      if (s.isSameDayAs(d)) return s;
    }
    return null;
  }

  ProgressPhotoState copyWith({
    List<ProgressSession>? sessions,
    bool? reminderEnabled,
    int? reminderFrequencyDays,
    bool? isPicking,
  }) {
    return ProgressPhotoState(
      sessions: sessions ?? this.sessions,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderFrequencyDays:
          reminderFrequencyDays ?? this.reminderFrequencyDays,
      isPicking: isPicking ?? this.isPicking,
    );
  }

  @override
  List<Object?> get props =>
      [sessions, reminderEnabled, reminderFrequencyDays, isPicking];
}
