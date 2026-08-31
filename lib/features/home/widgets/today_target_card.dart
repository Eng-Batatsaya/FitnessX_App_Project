import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/dashboard_data.dart';
import '../screens/activity_tracker_screen.dart';

class TodayTargetCard extends StatelessWidget {
  final DashboardData data;
  final VoidCallback onCheck;

  const TodayTargetCard({
    super.key,
    required this.data,
    required this.onCheck,
  });

  void _showTodayProgress(BuildContext context, AppColorsResolved colors) {
    final progress = data.todayTargetProgress;
    final waterLeft = (data.waterGoal - data.waterIntake).clamp(0.0, double.infinity);
    final stepsLeft = (data.stepsGoal - data.steps).clamp(0, 999999);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Progress",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.blackColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: colors.primaryColor1.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("${(progress * 100).toInt()}% Done",
                        style: TextStyle(color: colors.primaryColor1, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildProgressItem(
                colors,
                "Water Intake",
                "${data.waterIntake.toStringAsFixed(1)} / ${data.waterGoal.toInt()} L",
                data.waterIntake / data.waterGoal,
                waterLeft > 0 ? "باقي لك ${waterLeft.toStringAsFixed(1)} لتر" : "تم تحقيق الهدف! 💧",
                Icons.water_drop,
                colors.primaryColor1,
              ),
              const SizedBox(height: 20),
              _buildProgressItem(
                colors,
                "Foot Steps",
                "${data.steps} / ${data.stepsGoal} Steps",
                data.steps / data.stepsGoal,
                stepsLeft > 0 ? "باقي لك $stepsLeft خطوة" : "عاش يا بطل! 👟",
                Icons.directions_walk,
                colors.secondaryColor1,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.primaryGradient),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ActivityTrackerScreen(data: data)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text("View Full Analytics",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressItem(AppColorsResolved colors, String title, String value, double progress, String sub,
      IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: colors.blackColor, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(value, style: TextStyle(color: colors.grayColor1, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: colors.grayColor3.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 5),
        Text(sub, style: TextStyle(color: color.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final progress = data.todayTargetProgress;

    return GestureDetector(
      onTap: () => _showTodayProgress(context, colors),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primaryColor2.withOpacity(0.15),
              colors.primaryColor2.withOpacity(0.25),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today Target",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.blackColor,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colors.whiteColor,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primaryColor1),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.primaryGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  onCheck();
                  _showTodayProgress(context, colors);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                ),
                child: const Text(
                  "Check",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
