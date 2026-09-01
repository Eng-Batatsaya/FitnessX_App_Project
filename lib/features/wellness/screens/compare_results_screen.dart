// lib/features/wellness/screens/compare_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'progress_photo.dart';
import 'compare_results_detail_screen.dart';
import '../controllers/compare_results_cubit.dart';
import '../widgets/compare_results/tab_switcher.dart';
import '../widgets/compare_results/empty_state.dart';
import '../widgets/compare_results/facing_photo_row.dart';
import '../widgets/compare_results/session_picker_sheet.dart';
import '../widgets/compare_results/full_photos_dialog.dart';
import '../widgets/compare_results/back_home_button.dart';

class CompareResultsScreen extends StatelessWidget {
  const CompareResultsScreen({super.key, required this.sessions, this.cubit});
  final List<ProgressSession> sessions;
  final CompareResultsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
          value: cubit!, child: const _CompareResultsView());
    }
    return BlocProvider(
      create: (_) => CompareResultsCubit(sessions),
      child: const _CompareResultsView(),
    );
  }
}

class _CompareResultsView extends StatelessWidget {
  const _CompareResultsView();

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);
  static const Color goodGreen = Color(0xFF34C759);
  static const Color warnAmber = Color(0xFFE0A030);
  static const Color cardLavender = Color(0xFFEBF0FF);

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _formatDate(DateTime d) => '${d.day} ${_monthNames[d.month - 1]}';

  String _progressLabel(double c) {
    if (c >= 0.75) return 'Good';
    if (c >= 0.4) return 'Getting there';
    return 'Add more angles';
  }

  Color _progressColor(double c) {
    if (c >= 0.75) return goodGreen;
    if (c >= 0.4) return warnAmber;
    return greyText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: darkText),
        title: const Text('Result',
            style: TextStyle(
                color: darkText, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.share_outlined, color: darkText),
              onPressed: () => _shareResult(context)),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CompareResultsCubit, int>(
        builder: (context, _) {
          final cubit = context.read<CompareResultsCubit>();
          final compState = cubit.comparisonState;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TabSwitcher(
                  photoActive: true,
                  onTapPhoto: () {},
                  onTapStatistic: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => CompareResultsDetailScreen(
                              sessions: compState.sessions, cubit: cubit)),
                    );
                  },
                ),
              ),
              Expanded(
                child: compState.hasEnoughData
                    ? _buildPhotoTab(context, cubit, compState)
                    : CompareEmptyState(
                        icon: Icons.compare_outlined,
                        title: 'Not enough photos yet',
                        message:
                            'Add progress photos on at least 2 different days on the Progress Photo screen, then come back here to compare them.',
                        onBack: () => Navigator.of(context).pop(),
                      ),
              ),
              const BackHomeButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhotoTab(BuildContext context, CompareResultsCubit cubit,
      ComparisonState compState) {
    final before = compState.beforeSession;
    final after = compState.afterSession;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Average Progress',
                  style: TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const Spacer(),
              Text(_progressLabel(compState.completeness),
                  style: TextStyle(
                      color: _progressColor(compState.completeness),
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: compState.completeness,
              minHeight: 8,
              backgroundColor: cardLavender,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
            ),
          ),
          const SizedBox(height: 4),
          Text('${compState.matchedAngleCount} of 4 angles matched',
              style: const TextStyle(color: greyText, fontSize: 11)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _datePickerLabel(
                label: before != null ? _formatDate(before.date) : 'Pick date',
                onTap: () =>
                    _pickSession(context, cubit, compState, isBefore: true),
              ),
              _datePickerLabel(
                label: after != null ? _formatDate(after.date) : 'Pick date',
                onTap: () =>
                    _pickSession(context, cubit, compState, isBefore: false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (final facing in PhotoFacing.values) ...[
            FacingPhotoRow(
              facing: facing,
              beforePhoto: before?.photoFor(facing),
              afterPhoto: after?.photoFor(facing),
              onOpenPhoto: (photo) => openFullPhoto(context, photo),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _datePickerLabel(
      {required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: darkText, fontSize: 13, fontWeight: FontWeight.w700)),
          const Icon(Icons.arrow_drop_down, size: 18, color: greyText),
        ],
      ),
    );
  }

  Future<void> _pickSession(BuildContext context, CompareResultsCubit cubit,
      ComparisonState compState,
      {required bool isBefore}) async {
    final chosen = await showSessionPickerSheet(
      context,
      sessions: compState.sortedSessions,
      isBefore: isBefore,
      formatDate: _formatDate,
    );
    if (chosen != null) {
      if (isBefore) {
        cubit.selectBefore(chosen);
      } else {
        cubit.selectAfter(chosen);
      }
    }
  }

  void _shareResult(BuildContext context) {
    final compState = context.read<CompareResultsCubit>().comparisonState;
    final before = compState.beforeSession;
    final after = compState.afterSession;
    final report = StringBuffer('Progress Comparison\n\n');
    if (before != null && after != null) {
      report.writeln('Before: ${_formatDate(before.date)}');
      report.writeln('After: ${_formatDate(after.date)}');
      report.writeln('Angles matched: ${compState.matchedAngleCount} of 4');
      final change = compState.weightChangeKg;
      if (change != null) {
        report.writeln(
            'Weight change: ${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg');
      }
    } else {
      report.writeln('Not enough photos logged yet.');
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Share Result'),
        content: SelectableText(report.toString(),
            style: const TextStyle(fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close')),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: report.toString()));
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')));
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
