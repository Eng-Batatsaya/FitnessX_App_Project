import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../screens/workout_tracker_screen.dart';

class WorkoutProgressCard extends StatefulWidget {
  const WorkoutProgressCard({super.key});

  @override
  State<WorkoutProgressCard> createState() => _WorkoutProgressCardState();
}

class _WorkoutProgressCardState extends State<WorkoutProgressCard> {
  String _selectedRange = "Weekly";
  final List<String> _ranges = const ["Daily", "Weekly", "Monthly"];
  String _selectedDay = "Fri";
  final List<String> _days = const ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  final Map<String, Map<String, dynamic>> _dayDetails = {
    "Sun": {"percent": 60, "workout": "Fullbody Workout", "date": "23 May"},
    "Mon": {"percent": 45, "workout": "Lowerbody Workout", "date": "24 May"},
    "Tue": {"percent": 80, "workout": "Ab Workout", "date": "25 May"},
    "Wed": {"percent": 30, "workout": "Rest Day", "date": "26 May"},
    "Thu": {"percent": 55, "workout": "Leg Workout", "date": "27 May"},
    "Fri": {"percent": 90, "workout": "Upperbody Workout", "date": "28 May"},
    "Sat": {"percent": 70, "workout": "Cardio Workout", "date": "29 May"},
  };

  Future<void> _showRangePicker(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width - 90, button.size.height), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final colors = AppColors.of(context);

    final selected = await showMenu<String>(
      context: context,
      position: position,
      color: colors.whiteColor,
      items: _ranges
          .map((range) => PopupMenuItem<String>(
                value: range,
                child: Text(
                  range,
                  style: TextStyle(
                    color: range == _selectedRange ? AppColors.primaryColor1 : colors.blackColor,
                    fontWeight: range == _selectedRange ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ))
          .toList(),
    );

    if (selected != null && selected != _selectedRange) {
      setState(() => _selectedRange = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutTrackerScreen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Workout Progress", style: AppTextStyles.heading2.copyWith(color: colors.blackColor)),
              Builder(
                builder: (menuContext) => GestureDetector(
                  onTap: () => _showRangePicker(menuContext),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(_selectedRange, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.whiteColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: colors.grayColor3.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) => Divider(height: 1, color: colors.grayColor3)),
                                ),
                                Positioned(
                                  left: (MediaQuery.of(context).size.width - 120) / 7 * _days.indexOf(_selectedDay),
                                  bottom: 0,
                                  top: 30,
                                  child: Container(
                                    width: 30,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [colors.primaryColor2.withOpacity(0.2), colors.primaryColor2.withOpacity(0.05)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: WorkoutWavePainter(_days.indexOf(_selectedDay), colors),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ["100%", "80%", "60%", "40%", "20%", "0%"]
                                .map((label) => Text(label, style: TextStyle(fontSize: 10, color: colors.grayColor2)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _days.map((day) {
                        bool isSelected = day == _selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = day),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? colors.primaryColor2 : colors.grayColor2,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  top: 5,
                  left: (MediaQuery.of(context).size.width - 240) / 6 * _days.indexOf(_selectedDay) + 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colors.blackColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("$_selectedDay, ${_dayDetails[_selectedDay]!['date']}", style: TextStyle(fontSize: 8, color: colors.grayColor2)),
                            const SizedBox(width: 15),
                            Text("${_dayDetails[_selectedDay]!['percent']}% ↑",
                                style: const TextStyle(fontSize: 8, color: Color(0xFF42D08B), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(_dayDetails[_selectedDay]!['workout'],
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: colors.blackColor)),
                        const SizedBox(height: 6),
                        Container(
                          width: 100,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colors.grayColor3.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: (_dayDetails[_selectedDay]!['percent'] as int).toDouble(),
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: colors.primaryGradient),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutWavePainter extends CustomPainter {
  final int selectedIndex;
  final AppColorsResolved colors;
  WorkoutWavePainter(this.selectedIndex, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = colors.primaryColor2.withOpacity(0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = colors.secondaryColor1.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Adjust wave shape based on selected day to show variety
    double waveHeight1 = 0.65 - (selectedIndex * 0.05);
    double waveHeight2 = 0.75 + (selectedIndex * 0.02);

    final path1 = Path();
    path1.moveTo(0, size.height * waveHeight1);
    path1.cubicTo(
        size.width * 0.25, size.height * (waveHeight1 + 0.3), size.width * 0.35, size.height * (waveHeight1 - 0.45), size.width * 0.6, size.height * waveHeight1);
    path1.cubicTo(size.width * 0.75, size.height * (waveHeight1 + 0.2), size.width * 0.85, size.height * (waveHeight1 - 0.55), size.width, size.height * waveHeight1);

    final path2 = Path();
    path2.moveTo(0, size.height * waveHeight2);
    path2.cubicTo(
        size.width * 0.3, size.height * (waveHeight2 - 0.35), size.width * 0.6, size.height * (waveHeight2 + 0.15), size.width * 0.9, size.height * (waveHeight2 - 0.1));
    path2.lineTo(size.width, size.height * waveHeight2);

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);

    // Indicator dot position
    final dotX = (size.width / 6) * selectedIndex;
    // Simple logic to place the dot on the primary wave at the selected X
    double dotY = size.height * (waveHeight1 - 0.1); 

    canvas.drawCircle(Offset(dotX, dotY), 5, Paint()..color = colors.primaryColor2);
    canvas.drawCircle(Offset(dotX, dotY), 2.5, Paint()..color = colors.whiteColor);
  }

  @override
  bool shouldRepaint(covariant WorkoutWavePainter oldDelegate) => oldDelegate.selectedIndex != selectedIndex;
}
