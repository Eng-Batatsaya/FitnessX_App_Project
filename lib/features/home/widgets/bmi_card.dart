import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/models/dashboard_data.dart';
import '../screens/activity_tracker_screen.dart';

class BMICard extends StatelessWidget {
  final double height;
  final double weight;
  final DashboardData? data;

  const BMICard({
    super.key,
    this.height = 180.0,
    this.weight = 65.0,
    this.data,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) {
      return "You have a underweight";
    } else if (bmi < 25) {
      return "You have a normal weight";
    } else if (bmi < 30) {
      return "You have a overweight";
    } else {
      return "You have a obesity";
    }
  }

  void _showBMIDetails(BuildContext context, AppColorsResolved colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.grayColor3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "BMI Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.blackColor,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Body Mass Index (BMI) is a measure that uses your height and weight to work out if your weight is healthy.",
                style: TextStyle(color: colors.grayColor1, fontSize: 14),
              ),
              const SizedBox(height: 20),
              _buildCategoryRow(colors, "Underweight", "< 18.5", Colors.blue),
              _buildCategoryRow(colors, "Normal weight", "18.5 – 24.9", Colors.green),
              _buildCategoryRow(colors, "Overweight", "25.0 – 29.9", Colors.orange),
              _buildCategoryRow(colors, "Obesity", "≥ 30.0", Colors.red),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colors.primaryColor2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: colors.primaryColor1),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your BMI is ${bmi.toStringAsFixed(1)}, which means $bmiCategory.",
                        style: TextStyle(color: colors.blackColor, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryRow(AppColorsResolved colors, String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: colors.blackColor, fontSize: 14)),
            ],
          ),
          Text(range, style: TextStyle(color: colors.grayColor1, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    String bmiString = bmi.toStringAsFixed(1).replaceAll('.', ',');

    return GestureDetector(
      onTap: () => _showBMIDetails(context, colors),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              colors.primaryColor2.withOpacity(0.8),
              colors.primaryColor1.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              left: 150,
              top: 40,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.white.withOpacity(0.3)),
            ),
            Positioned(
              left: 180,
              bottom: 30,
              child: CircleAvatar(radius: 6, backgroundColor: Colors.white.withOpacity(0.2)),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: CircleAvatar(radius: 30, backgroundColor: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "BMI (Body Mass Index)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bmiCategory,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: colors.secondaryGradient),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _showBMIDetails(context, colors),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            ),
                            child: const Text("View More", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: colors.whiteColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CustomPaint(
                          painter: BMIPiePainter(bmi: bmi, colors: colors),
                        ),
                      ),
                      Positioned(
                        right: 25,
                        top: 40,
                        child: Text(
                          bmiString,
                          style: TextStyle(
                            color: colors.isDark ? colors.blackColor : Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BMIPiePainter extends CustomPainter {
  final double bmi;
  final AppColorsResolved colors;

  BMIPiePainter({required this.bmi, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintArc = Paint()
      ..shader = LinearGradient(
        colors: [colors.secondaryColor1, colors.secondaryColor2],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    // Drawing the pie segment based on BMI
    // Assume BMI 20 is pi/2 (90 degrees)
    double sweepAngle = (bmi / 20) * (math.pi / 2);
    sweepAngle = sweepAngle.clamp(0.0, 2 * math.pi);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2.5,
      sweepAngle,
      true,
      paintArc,
    );
  }

  @override
  bool shouldRepaint(covariant BMIPiePainter oldDelegate) => oldDelegate.bmi != bmi;
}
