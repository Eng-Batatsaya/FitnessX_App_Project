// lib/features/wellness/screens/sleep_schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add_alarm_screen.dart';

class SleepScheduleScreen extends StatefulWidget {
  const SleepScheduleScreen({super.key});

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _DaySchedule {
  _DaySchedule({
    required this.bedtimeLabel,
    required this.bedtimeCountdown,
    required this.alarmLabel,
    required this.alarmCountdown,
    required this.sleepDurationLabel,
    required this.sleepPercent,
    this.bedtimeEnabled = true,
    this.alarmEnabled = true,
    this.alarmSound = 'Classic',
    this.snoozeMinutes = 10,
    this.alarmLabel2 = '',
  });

  String bedtimeLabel;
  String bedtimeCountdown;
  String alarmLabel;
  String alarmCountdown;
  String sleepDurationLabel;
  double sleepPercent;
  bool bedtimeEnabled;
  bool alarmEnabled;
  String alarmSound;
  int snoozeMinutes;
  String alarmLabel2; // custom name for the alarm, e.g. "Work Days"
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen> {
  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color cardLavender = Color(0xFFEBF2FF);
  static const Color chipInactive = Color(0xFFF7F8F8);
  static const Color accentPink = Color(0xFFDB99DF);
  static const Color summaryBg = Color(0xFFF8EAF9);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);

  static const List<String> _weekdayShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _sleepSounds = [
    'Rain',
    'White Noise',
    'Ocean Waves',
    'Silent'
  ];

  late final List<DateTime> _dates;
  late Map<int, _DaySchedule> _schedules;
  late int _selectedIndex;

  String _sleepSound = 'Rain';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(
        14, (i) => DateTime(today.year, today.month, today.day - 3 + i));
    _selectedIndex = 3;
    _schedules = _defaultSchedules();
  }

  Map<int, _DaySchedule> _defaultSchedules() {
    return {
      for (int i = 0; i < _dates.length; i++)
        i: _DaySchedule(
          bedtimeLabel: '09:00pm',
          bedtimeCountdown: 'in 6 hours 22 minutes',
          alarmLabel: '05:10am',
          alarmCountdown: 'in 14 hours 30 minutes',
          sleepDurationLabel: '8 hours 10 minutes',
          sleepPercent: 0.96,
        ),
    };
  }

  _DaySchedule get _current => _schedules[_selectedIndex]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: darkText),
        title: const Text(
          'Sleep Schedule',
          style: TextStyle(
              color: darkText, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [_buildScreenMenu()],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIdealHoursCard(),
                const SizedBox(height: 24),
                const Text('Your Schedule',
                    style: TextStyle(
                        color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                _buildDaySelector(),
                const SizedBox(height: 18),
                _buildScheduleItem(
                  entryKey: 'bedtime',
                  emoji: '🛌',
                  iconBg: const Color(0xFFE7E4FB),
                  title: 'Bedtime, ',
                  time: _current.bedtimeLabel,
                  subtitle: _current.bedtimeCountdown,
                  extraLine: '🎵 Sound: $_sleepSound',
                  value: _current.bedtimeEnabled,
                  onChanged: (v) => setState(() => _current.bedtimeEnabled = v),
                ),
                const SizedBox(height: 12),
                _buildScheduleItem(
                  entryKey: 'alarm',
                  emoji: '⏰',
                  iconBg: const Color(0xFFFFE3E8),
                  title: 'Alarm, ',
                  time: _current.alarmLabel,
                  subtitle: _current.alarmCountdown,
                  extraLine:
                      '🔔 ${_current.alarmSound} · Snooze ${_current.snoozeMinutes}min'
                      '${_current.alarmLabel2.isNotEmpty ? " · ${_current.alarmLabel2}" : ""}',
                  value: _current.alarmEnabled,
                  onChanged: (v) => setState(() => _current.alarmEnabled = v),
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(bottom: 24, right: 20, child: _buildFab()),
        ],
      ),
    );
  }

  // --- Top-right "..." screen menu ---------------------------------------

  Widget _buildScreenMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: darkText),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        switch (value) {
          case 'sound':
            _pickSleepSound();
            break;
          case 'notifications':
            setState(() => _notificationsEnabled = !_notificationsEnabled);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Notifications ${_notificationsEnabled ? 'enabled' : 'disabled'}')),
            );
            break;
          case 'reset':
            _confirmReset();
            break;
          case 'share':
            _showShareReport();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 'sound', child: Text('Sleep Sound  ·  $_sleepSound')),
        PopupMenuItem(
          value: 'notifications',
          child: Text(_notificationsEnabled
              ? 'Turn Off Notifications'
              : 'Turn On Notifications'),
        ),
        const PopupMenuItem(value: 'reset', child: Text('Reset Schedule')),
        const PopupMenuItem(value: 'share', child: Text('Share Report')),
      ],
    );
  }

  Future<void> _pickSleepSound() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sleep Sound',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: darkText)),
                ),
              ),
              ..._sleepSounds.map((sound) {
                final selected = sound == _sleepSound;
                return ListTile(
                  title: Text(sound,
                      style: TextStyle(
                          color: darkText,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500)),
                  trailing: selected
                      ? const Icon(Icons.check, color: primaryBlue)
                      : null,
                  onTap: () => Navigator.of(context).pop(sound),
                );
              }),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    if (result != null) {
      setState(() => _sleepSound = result);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sleep sound set to $result')));
    }
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset schedule?'),
        content: const Text(
            'This restores every day back to the default bedtime and alarm.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      setState(() => _schedules = _defaultSchedules());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule reset to defaults')));
    }
  }

  void _showShareReport() {
    final date = _dates[_selectedIndex];
    final report = 'Sleep Report — ${date.day}/${date.month}/${date.year}\n\n'
        'Bedtime: ${_current.bedtimeLabel}\n'
        'Alarm: ${_current.alarmLabel}\n'
        'Expected sleep: ${_current.sleepDurationLabel}\n'
        'Progress: ${(_current.sleepPercent * 100).round()}%\n'
        'Sleep sound: $_sleepSound';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Report'),
        content: SelectableText(report,
            style: const TextStyle(fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: report));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  // --- Ideal hours card ----------------------------------------------

  Widget _buildIdealHoursCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: cardLavender, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ideal Hours for Sleep',
                    style: TextStyle(
                        color: darkText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                const Text('8hours 30minutes',
                    style: TextStyle(
                        color: primaryBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showSleepTipsSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                  ),
                  child: const Text('Learn More',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          _buildMoonIllustration(),
        ],
      ),
    );
  }

  void _showSleepTipsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: chipInactive,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const Text('Why 8 hours 30 minutes?',
                  style: TextStyle(
                      color: darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const Text(
                'Adults typically need 7–9 hours of sleep for the body to '
                'complete full sleep cycles — deep sleep for physical '
                'recovery and REM sleep for memory and focus. Going to bed '
                'and waking up at consistent times helps your body reach '
                'this target more reliably than the total hours alone.',
                style: TextStyle(color: greyText, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Got it',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoonIllustration() {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 4,
            child: Container(
              width: 70,
              height: 26,
              decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const Positioned(
              top: 0,
              right: 6,
              child: Text('✨', style: TextStyle(fontSize: 14))),
          const Positioned(
              top: 14,
              left: 2,
              child: Text('⭐', style: TextStyle(fontSize: 12))),
          const Text('🌙', style: TextStyle(fontSize: 44)),
          Positioned(
            top: 8,
            right: 0,
            child: Text('Z z',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          final date = _dates[index];
          final weekday = _weekdayShort[date.weekday - 1];
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 50,
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : chipInactive,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weekday,
                      style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white70 : greyText)),
                  const SizedBox(height: 4),
                  Text('${date.day}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : darkText)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleItem({
    required String entryKey,
    required String emoji,
    required Color iconBg,
    required String title,
    required String time,
    required String subtitle,
    required String extraLine,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    Text(time,
                        style: const TextStyle(color: greyText, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: greyText, fontSize: 12)),
                const SizedBox(height: 2),
                Text(extraLine,
                    style: const TextStyle(color: greyText, fontSize: 10)),
              ],
            ),
          ),
          Switch(
              value: value, onChanged: onChanged, activeThumbColor: accentPink),
          _buildEntryMenu(
              entryKey: entryKey, title: title.replaceAll(',', '').trim()),
        ],
      ),
    );
  }

  Widget _buildEntryMenu({required String entryKey, required String title}) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: greyText, size: 18),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (action) => _handleEntryAction(entryKey, title, action),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(
            value: 'duplicate', child: Text('Duplicate to another day')),
        PopupMenuItem(
            value: 'delete',
            child: Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    );
  }

  void _handleEntryAction(String entryKey, String title, String action) {
    switch (action) {
      case 'edit':
        _openAddAlarm();
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title duplicated to another day.')));
        break;
      case 'delete':
        setState(() {
          if (entryKey == 'bedtime') {
            _current.bedtimeEnabled = false;
          } else {
            _current.alarmEnabled = false;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title turned off for this day.')));
        break;
    }
  }

  Future<void> _openAddAlarm() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const AddAlarmScreen()),
    );
    if (!mounted) return;
    if (result == null) return;
    _applyAlarmResult(result);
  }

  void _applyAlarmResult(Map<String, dynamic> result) {
    final repeatLabel = result['repeatLabel'] as String? ?? 'Once';
    final targetIndexes = _indexesForRepeat(repeatLabel).toSet()
      ..add(_selectedIndex);

    setState(() {
      for (final i in targetIndexes) {
        _schedules[i]
          ?..bedtimeLabel = result['bedtimeLabel']
          ..bedtimeCountdown = result['bedtimeCountdown']
          ..alarmLabel = result['alarmLabel']
          ..alarmCountdown = result['alarmCountdown']
          ..sleepDurationLabel = result['sleepDurationLabel']
          ..sleepPercent = result['sleepPercent']
          ..alarmSound = result['alarmSound'] ?? 'Classic'
          ..snoozeMinutes = result['snoozeMinutes'] ?? 10
          ..alarmLabel2 = result['alarmLabel2'] ?? ''
          ..bedtimeEnabled = true
          ..alarmEnabled = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarm applied ($repeatLabel) ✓')));
  }

  List<int> _indexesForRepeat(String repeatLabel) {
    switch (repeatLabel) {
      case 'Every day':
        return List.generate(_dates.length, (i) => i);
      case 'Mon to Fri':
        return [
          for (int i = 0; i < _dates.length; i++)
            if (_dates[i].weekday >= DateTime.monday &&
                _dates[i].weekday <= DateTime.friday)
              i
        ];
      case 'Weekends':
        return [
          for (int i = 0; i < _dates.length; i++)
            if (_dates[i].weekday == DateTime.saturday ||
                _dates[i].weekday == DateTime.sunday)
              i
        ];
      case 'Once':
      default:
        return [_selectedIndex];
    }
  }

  Widget _buildSummaryCard() {
    final percent = _current.sleepPercent.clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: summaryBg, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You will get ${_current.sleepDurationLabel}\nfor tonight.',
              style: const TextStyle(
                  color: darkText, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final fillWidth = constraints.maxWidth * percent;
              return SizedBox(
                height: 22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 10,
                        width: fillWidth,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [primaryBlue, accentPink]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      '${(percent * 100).round()}%',
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 4),
                          Shadow(color: Colors.white, blurRadius: 4)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: _openAddAlarm,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [primaryBlue, accentPink]),
          boxShadow: [
            BoxShadow(
                color: accentPink.withValues(alpha: 0.5),
                blurRadius: 18,
                offset: const Offset(0, 8))
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
