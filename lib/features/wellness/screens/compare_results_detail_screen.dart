// lib/features/wellness/screens/compare_results_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'progress_photo.dart';
import 'compare_results_screen.dart';
import '../controllers/compare_results_cubit.dart';
import '../widgets/compare_results/tab_switcher.dart';
import '../widgets/compare_results/empty_state.dart';
import '../widgets/compare_results/weight_trend_chart.dart';
import '../widgets/compare_results/info_row.dart';
import '../widgets/compare_results/full_photos_dialog.dart';
import '../widgets/compare_results/back_home_button.dart';

class CompareResultsDetailScreen extends StatelessWidget {
  const CompareResultsDetailScreen(
      {super.key, required this.sessions, this.cubit});
  final List<ProgressSession> sessions;
  final CompareResultsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
          value: cubit!, child: const _CompareResultsDetailView());
    }
    return BlocProvider(
      create: (_) => CompareResultsCubit(sessions),
      child: const _CompareResultsDetailView(),
    );
  }
}

class _CompareResultsDetailView extends StatelessWidget {
  const _CompareResultsDetailView();

  static const Color darkText = Color(0xFF1E1B2E);
  static const Color goodGreen = Color(0xFF34C759);
  static const Color warnAmber = Color(0xFFE0A030);
  static const Color rowBg = Color(0xFFF4F5F7);

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
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                color: rowBg, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
                icon:
                    const Icon(Icons.share_outlined, color: darkText, size: 20),
                onPressed: () => _shareResult(context)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: rowBg, borderRadius: BorderRadius.circular(12)),
            child: _buildScreenMenu(context),
          ),
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
                  photoActive: false,
                  onTapStatistic: () {},
                  onTapPhoto: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => CompareResultsScreen(
                              sessions: compState.sessions, cubit: cubit)),
                    );
                  },
                ),
              ),
              Expanded(
                child: compState.hasEnoughData
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WeightTrendChart(
                                history: compState.weightHistory,
                                monthNames: _monthNames),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    compState.beforeSession != null
                                        ? _formatDate(
                                            compState.beforeSession!.date)
                                        : '—',
                                    style: const TextStyle(
                                        color: darkText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    compState.afterSession != null
                                        ? _formatDate(
                                            compState.afterSession!.date)
                                        : '—',
                                    style: const TextStyle(
                                        color: darkText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildStatsList(compState),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                    : const CompareEmptyState(
                        icon: Icons.insert_chart_outlined,
                        title: 'Not enough photos yet',
                        message:
                            'Add progress photos on at least 2 different days to see stats here.',
                      ),
              ),
              const BackHomeButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScreenMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: darkText, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        final compState = context.read<CompareResultsCubit>().comparisonState;
        switch (value) {
          case 'view':
            final photos = <ProgressPhoto>[
              ...?compState.beforeSession?.photos,
              ...?compState.afterSession?.photos
            ];
            showOriginalPhotosGrid(context, photos);
            break;
          case 'progress':
            Navigator.of(context).popUntil((r) => r.isFirst);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'view', child: Text('View Original Photos')),
        PopupMenuItem(value: 'progress', child: Text('Back to Progress Photo')),
      ],
    );
  }

  Widget _buildStatsList(ComparisonState compState) {
    final before = compState.beforeSession;
    final after = compState.afterSession;
    final change = compState.weightChangeKg;

    final rows = <Widget>[];

    if (before?.weightKg != null && after?.weightKg != null) {
      rows.add(InfoRow(
          label: 'Weight Before',
          value: '${before!.weightKg!.toStringAsFixed(1)} kg'));
      rows.add(InfoRow(
          label: 'Weight After',
          value: '${after!.weightKg!.toStringAsFixed(1)} kg'));
      rows.add(InfoRow(
        label: 'Weight Change',
        value: '${change! > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
        valueColor: change <= 0 ? goodGreen : warnAmber,
      ));
    } else {
      rows.add(const InfoRow(label: 'Weight Change', value: 'Not logged'));
    }

    rows.add(
        InfoRow(label: 'Days Tracked', value: '${compState.daysBetween} days'));
    rows.add(InfoRow(
        label: 'Angles Compared',
        value: '${compState.matchedAngleCount} of 4'));
    rows.add(InfoRow(
        label: 'Sessions Logged', value: '${compState.sessions.length}'));

    return Column(children: rows);
  }

  void _shareResult(BuildContext context) {
    final compState = context.read<CompareResultsCubit>().comparisonState;
    final before = compState.beforeSession;
    final after = compState.afterSession;
    final report = StringBuffer('Progress Comparison\n\n');
    if (before != null && after != null) {
      report.writeln('Before: ${_formatDate(before.date)}');
      report.writeln('After: ${_formatDate(after.date)}');
      final change = compState.weightChangeKg;
      if (change != null) {
        report.writeln(
            'Weight: ${before.weightKg!.toStringAsFixed(1)} kg → ${after.weightKg!.toStringAsFixed(1)} kg '
            '(${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg)');
      }
      report.writeln('Days tracked: ${compState.daysBetween}');
      report.writeln('Angles compared: ${compState.matchedAngleCount} of 4');
      report.writeln('Sessions logged: ${compState.sessions.length}');
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
