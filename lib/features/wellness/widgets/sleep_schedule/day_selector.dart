// lib/features/wellness/widgets/sleep_schedule/day_selector.dart
import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<DateTime> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color chipInactive = Color(0xFFF7F8F8);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);
  static const List<String> _weekdayShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final date = dates[index];
          final weekday = _weekdayShort[date.weekday - 1];
          return GestureDetector(
            onTap: () => onSelect(index),
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
}
