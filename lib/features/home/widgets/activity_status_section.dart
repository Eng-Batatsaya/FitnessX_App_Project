import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/dashboard_data.dart';
import '../screens/activity_tracker_screen.dart';
import '../../wellness/screens/sleep_schedule_screen.dart';

class ActivityStatusSection extends StatelessWidget {
  final DashboardData data;
  final Function(double) onAddWater; // Changed from VoidCallback to support amounts
  final VoidCallback onHeartRateUpdate;

  const ActivityStatusSection({
    super.key,
    required this.data,
    required this.onAddWater,
    required this.onHeartRateUpdate,
  });

  void _showWaterDetails(BuildContext context, AppColorsResolved colors) {
    final waterLeft = (data.waterGoal - data.waterIntake).clamp(0.0, double.infinity);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hydration Tracker",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.blackColor)),
              const SizedBox(height: 10),
              Text(
                waterLeft > 0 ? "You need $waterLeft L more to reach your goal." : "Great job! You reached your goal! 💧",
                style: TextStyle(color: colors.grayColor1, fontSize: 14),
              ),
              const SizedBox(height: 25),
              Text("Quick Add", style: TextStyle(color: colors.blackColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAddOption(context, colors, "250ml", 0.25, Icons.local_drink_outlined),
                  _buildQuickAddOption(context, colors, "500ml", 0.5, Icons.water_drop_outlined),
                  _buildQuickAddOption(context, colors, "750ml", 0.75, Icons.wine_bar_outlined),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colors.secondaryColor2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.secondaryColor1),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Tip: Drinking water before meals can help with weight loss.",
                        style: TextStyle(color: colors.blackColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAddOption(BuildContext context, AppColorsResolved colors, String label, double amount, IconData icon) {
    return GestureDetector(
      onTap: () {
        onAddWater(amount);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: colors.primaryColor2.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primaryColor1),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: colors.grayColor1, fontSize: 12)),
        ],
      ),
    );
  }

  void _showCaloriesDetails(BuildContext context, AppColorsResolved colors) {
    int caloriesLeft = data.caloriesGoal - data.caloriesBurned;
    double progress = (data.caloriesBurned / data.caloriesGoal).clamp(0.0, 1.0);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calories Analysis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.blackColor)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: colors.primaryColor2.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primaryColor1),
                        ),
                      ),
                      Text("${(progress * 100).toInt()}%",
                          style: TextStyle(fontWeight: FontWeight.bold, color: colors.blackColor)),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMacroInfo(colors, "Burned", "${data.caloriesBurned} kCal", colors.primaryColor1),
                      const SizedBox(height: 10),
                      _buildMacroInfo(colors, "Goal", "${data.caloriesGoal} kCal", colors.grayColor2),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Daily Macros", style: TextStyle(color: colors.blackColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroBar(colors, "Proteins", 0.6, Colors.orange),
                  _buildMacroBar(colors, "Carbs", 0.4, Colors.blue),
                  _buildMacroBar(colors, "Fats", 0.3, Colors.red),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colors.primaryColor1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  caloriesLeft > 0 
                      ? "You have $caloriesLeft kCal left. Consider a protein-rich snack! 🍎" 
                      : "Daily goal achieved! Try to maintain this balance. ✨",
                  style: TextStyle(color: colors.blackColor, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroInfo(AppColorsResolved colors, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: colors.grayColor1, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildMacroBar(AppColorsResolved colors, String label, double progress, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(5),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: colors.grayColor1, fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Activity Status",
          style: AppTextStyles.heading2.copyWith(color: colors.blackColor),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            onHeartRateUpdate();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityTrackerScreen(data: data),
              ),
            );
          },
          child: _buildHeartRateCard(colors),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showWaterDetails(context, colors),
                child: _buildWaterIntakeCard(colors),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to sleep details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SleepScheduleScreen(),
                        ),
                      );
                    },
                    child: _buildSleepCard(colors),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _showCaloriesDetails(context, colors),
                    child: _buildCaloriesCard(colors),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeartRateCard(AppColorsResolved colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primaryColor2.withOpacity(0.1),
            colors.primaryColor2.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Heart Rate", style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                const SizedBox(height: 5),
                Text("${data.heartRate} BPM", style: TextStyle(color: colors.primaryColor1, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: HeartRatePainter(points: data.heartRatePoints, colors: colors),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.secondaryGradient),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                data.heartRateTimestamp,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterIntakeCard(AppColorsResolved colors) {
    double waterPercentage = (data.waterIntake / data.waterGoal).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 380, // Slightly taller to accommodate more updates
            decoration: BoxDecoration(
              color: colors.grayColor3.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: waterPercentage,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors.primaryGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Water Intake", style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
                const SizedBox(height: 5),
                Text("${data.waterIntake.toStringAsFixed(1)} Liters", style: TextStyle(color: colors.primaryColor1, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Text("Real time updates", style: AppTextStyles.bodySmall.copyWith(color: colors.grayColor1)),
                const SizedBox(height: 10),
                _buildTimeline(colors),
                const SizedBox(height: 10),
                Text(
                  "${(waterPercentage * 100).toInt()}% of goal",
                  style: TextStyle(fontSize: 10, color: colors.grayColor2, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(AppColorsResolved colors) {
    final updates = data.waterUpdates;

    return Column(
      children: updates.map((item) {
        bool isActive = item.isActive;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? colors.secondaryColor2 : colors.secondaryColor1.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                if (updates.indexOf(item) != updates.length - 1)
                  Container(
                    width: 1,
                    height: 40,
                    color: colors.secondaryColor1.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.time, style: TextStyle(fontSize: 10, color: colors.grayColor2)),
                Text(item.amount, style: TextStyle(fontSize: 10, color: isActive ? colors.secondaryColor2 : colors.secondaryColor1, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSleepCard(AppColorsResolved colors) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sleep", style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
          const SizedBox(height: 5),
          Text(data.sleepDuration, style: TextStyle(color: colors.primaryColor1, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: SleepWavePainter(quality: data.sleepQuality, colors: colors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(AppColorsResolved colors) {
    double calorieProgress = (data.caloriesBurned / data.caloriesGoal).clamp(0.0, 1.0);
    int caloriesLeft = data.caloriesGoal - data.caloriesBurned;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colors.blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 20, color: colors.primaryColor1),
              const SizedBox(width: 5),
              Text("Calories", style: AppTextStyles.heading3.copyWith(color: colors.blackColor)),
            ],
          ),
          const SizedBox(height: 5),
          Text("${data.caloriesBurned} kCal", style: TextStyle(color: colors.primaryColor1, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: calorieProgress,
                    strokeWidth: 8,
                    backgroundColor: colors.primaryColor2.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primaryColor1),
                  ),
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.primaryGradient),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${caloriesLeft > 0 ? caloriesLeft : 0}kCal\nleft",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 8),
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

class HeartRatePainter extends CustomPainter {
  final List<double> points;
  final AppColorsResolved colors;

  HeartRatePainter({required this.points, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = colors.primaryColor1
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.primaryColor1.withOpacity(0.3),
          colors.primaryColor1.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * points[0]);

    for (int i = 1; i < points.length; i++) {
      double x = (i / (points.length - 1)) * size.width;
      double y = size.height * points[i];
      path.lineTo(x, y);
    }

    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, paint);

    // Peak dot (find the minimum Y value which is the peak)
    double minVal = points[0];
    int minIndex = 0;
    for (int i = 1; i < points.length; i++) {
      if (points[i] < minVal) {
        minVal = points[i];
        minIndex = i;
      }
    }

    canvas.drawCircle(
      Offset((minIndex / (points.length - 1)) * size.width, size.height * minVal),
      4,
      Paint()..color = AppColors.secondaryColor2,
    );
  }

  @override
  bool shouldRepaint(covariant HeartRatePainter oldDelegate) => oldDelegate.points != points;
}

class SleepWavePainter extends CustomPainter {
  final double quality;
  final AppColorsResolved colors;

  SleepWavePainter({required this.quality, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = colors.primaryColor1.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = colors.secondaryColor1.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    void drawWave(Path path, double amplitude, double frequency, double phase) {
      path.moveTo(0, size.height / 2);
      for (double x = 0; x <= size.width; x++) {
        double y = amplitude * math.sin((x / size.width) * 2 * math.pi * frequency + phase) + size.height / 2;
        path.lineTo(x, y);
      }
    }

    // Adjust amplitude/frequency based on quality
    final path1 = Path();
    drawWave(path1, 10 * quality, 2, 0);
    canvas.drawPath(path1, paint1);

    final path2 = Path();
    drawWave(path2, 8 * quality, 2.5, math.pi / 2);
    canvas.drawPath(path2, paint2);

    final path3 = Path();
    drawWave(path3, 12 * quality, 1.5, math.pi);
    canvas.drawPath(path3, paint1);
  }

  @override
  bool shouldRepaint(covariant SleepWavePainter oldDelegate) => oldDelegate.quality != quality;
}
