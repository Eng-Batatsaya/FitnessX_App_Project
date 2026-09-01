// lib/features/wellness/screens/progress_photo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/widgets/custom_bottom_nav_bar.dart';
import 'compare_results_screen.dart';
import 'progress_photo.dart';
import '../controllers/progress_photo_cubit.dart';
import '../controllers/progress_photo_state.dart';
import '../widgets/progress_photo/add_photo_sheet.dart';
import '../widgets/progress_photo/clear_all_dialog.dart';
import '../widgets/progress_photo/compare_row.dart';
import '../widgets/progress_photo/empty_gallery_state.dart';
import '../widgets/progress_photo/facing_picker_sheet.dart';
import '../widgets/progress_photo/gallery_header.dart';
import '../widgets/progress_photo/reminder_card.dart';
import '../widgets/progress_photo/reminder_frequency_sheet.dart';
import '../widgets/progress_photo/session_row.dart';
import '../widgets/progress_photo/track_card.dart';
import '../widgets/progress_photo/tracking_info_sheet.dart';
import '../widgets/progress_photo/weight_prompt_dialog.dart';

class ProgressPhotoScreen extends StatelessWidget {
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressPhotoCubit(),
      child: const _ProgressPhotoView(),
    );
  }
}

class _ProgressPhotoView extends StatelessWidget {
  const _ProgressPhotoView();

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

  static final ImagePicker _picker = ImagePicker();

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.whiteColor,
      appBar: AppBar(
        backgroundColor: colors.whiteColor,
        elevation: 0,
        leading: BackButton(
          color: colors.blackColor,
        ),
        title: Text(
          'Progress Photo',
          style: TextStyle(
            color: colors.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          _buildScreenMenu(context),
        ],
      ),
      body: BlocBuilder<ProgressPhotoCubit, ProgressPhotoState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.reminderEnabled) ...[
                  ReminderCard(
                    nextDateLabel: _formatDate(state.nextReminderDate),
                    dayNumber: state.nextReminderDate.day,
                    onClose: () {
                      context
                          .read<ProgressPhotoCubit>()
                          .setReminderEnabled(false);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                TrackCard(
                  onLearnMore: () {
                    showTrackingInfoSheet(context);
                  },
                ),

                const SizedBox(height: 16),

                CompareRow(
                  onCompare: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return CompareResultsScreen(
                            sessions: state.sessions,
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                GalleryHeader(
                  hasSessions: state.sessions.isNotEmpty,
                  isPicking: state.isPicking,
                  onAddPhoto: () {
                    _openAddPhotoFlow(context);
                  },
                ),

                const SizedBox(height: 12),

                if (state.sessions.isEmpty)
                  EmptyGalleryState(
                    onTap: state.isPicking
                        ? null
                        : () {
                            _openAddPhotoFlow(context);
                          },
                  )
                else
                  ...state.sessions.map(
                    (session) {
                      return SessionRow(
                        session: session,
                        dateLabel: _formatDate(session.date),
                      );
                    },
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 3,
      ),
    );
  }

  Widget _buildScreenMenu(BuildContext context) {
    return BlocBuilder<ProgressPhotoCubit, ProgressPhotoState>(
      builder: (context, state) {
        final cubit = context.read<ProgressPhotoCubit>();
        final colors = AppColors.of(context);

        return Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: colors.grayColor1.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: PopupMenuButton<String>(
            icon: Icon(
              Icons.more_horiz,
              color: colors.blackColor,
              size: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (value) async {
              switch (value) {
                case 'reminder_toggle':
                  cubit.setReminderEnabled(
                    !state.reminderEnabled,
                  );
                  break;

                case 'frequency':
                  final result = await showReminderFrequencySheet(
                    context,
                    state.reminderFrequencyDays,
                  );

                  if (result != null) {
                    cubit.setReminderFrequency(result);
                  }
                  break;

                case 'clear':
                  final confirmed = await showClearAllDialog(context);

                  if (confirmed == true) {
                    cubit.clearAll();
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reminder_toggle',
                child: Text(
                  state.reminderEnabled
                      ? 'Turn Off Reminder'
                      : 'Turn On Reminder',
                ),
              ),
              PopupMenuItem(
                value: 'frequency',
                child: Text(
                  'Reminder Every ${state.reminderFrequencyDays} Days',
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text(
                  'Clear All Photos',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAddPhotoFlow(BuildContext context) async {
    final cubit = context.read<ProgressPhotoCubit>();

    final source = await showAddPhotoSheet(context);

    if (!context.mounted) return;

    if (source == null) return;

    cubit.setPicking(true);

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (!context.mounted) return;

      if (picked == null) return;

      final facing = await showFacingPickerSheet(context);

      if (!context.mounted) return;

      if (facing == null) return;

      final bytes = await picked.readAsBytes();

      final today = DateTime.now();

      final existing = cubit.state.sessionForDate(today);

      double? weight;

      if (existing == null) {
        weight = await showWeightPromptDialog(context);

        if (!context.mounted) return;
      }

      cubit.addPhoto(
        date: today,
        facing: facing,
        bytes: bytes,
        weight: weight,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${facing.label} photo added ✓',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not get the photo: $e',
            ),
          ),
        );
      }
    } finally {
      cubit.setPicking(false);
    }
  }
}