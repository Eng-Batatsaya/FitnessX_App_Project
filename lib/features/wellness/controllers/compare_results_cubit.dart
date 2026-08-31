// lib/features/wellness/controllers/compare_results_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/progress_photo.dart';

/// Wraps the existing (mutable) ComparisonState so both tab screens can
/// share one instance through proper DI instead of threading it manually
/// through constructors. Emits a revision number — the state itself
/// mutates in place, this Cubit just tells BlocBuilder "something changed".
class CompareResultsCubit extends Cubit<int> {
  CompareResultsCubit(List<ProgressSession> sessions,
      {ComparisonState? initial})
      : comparisonState = initial ??
            (ComparisonState(sessions: sessions)..ensureDefaultSelection()),
        super(0);

  final ComparisonState comparisonState;

  void _refresh() => emit(state + 1);

  void selectBefore(ProgressSession session) {
    comparisonState.beforeSession = session;
    _refresh();
  }

  void selectAfter(ProgressSession session) {
    comparisonState.afterSession = session;
    _refresh();
  }
}
