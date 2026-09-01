// lib/features/wellness/controllers/progress_photo_cubit.dart
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/progress_photo.dart';
import 'progress_photo_state.dart';

class ProgressPhotoCubit extends Cubit<ProgressPhotoState> {
  ProgressPhotoCubit() : super(const ProgressPhotoState());

  void setReminderEnabled(bool value) =>
      emit(state.copyWith(reminderEnabled: value));

  void setReminderFrequency(int days) =>
      emit(state.copyWith(reminderFrequencyDays: days));

  void clearAll() => emit(state.copyWith(sessions: []));

  void setPicking(bool value) => emit(state.copyWith(isPicking: value));

  /// Adds a photo to today's session — creating the session if this is the
  /// first photo of the day, or replacing the photo for that angle if one
  /// already exists.
  void addPhoto({
    required DateTime date,
    required PhotoFacing facing,
    required Uint8List bytes,
    double? weight,
  }) {
    final sessions = List<ProgressSession>.from(state.sessions);
    var session = state.sessionForDate(date);

    if (session == null) {
      session = ProgressSession(date: date, weightKg: weight);
      sessions.insert(0, session);
    }
    session.photos.removeWhere((p) => p.facing == facing);
    session.photos.add(ProgressPhoto(facing: facing, bytes: bytes));

    emit(state.copyWith(sessions: sessions));
  }
}
