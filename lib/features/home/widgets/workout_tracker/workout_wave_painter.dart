import 'package:flutter/material.dart';

class WorkoutWavePainter extends CustomPainter {
  final Color color;
  final Color primaryColor;
  final int selectedIndex;
  WorkoutWavePainter(
      {required this.color,
      required this.primaryColor,
      required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.65);
    path1.cubicTo(size.width * 0.25, size.height * 0.95, size.width * 0.35,
        size.height * 0.2, size.width * 0.6, size.height * 0.5);
    path1.cubicTo(size.width * 0.75, size.height * 0.85, size.width * 0.85,
        size.height * 0.1, size.width, size.height * 0.45);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    path2.cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.6,
        size.height * 0.9, size.width * 0.9, size.height * 0.65);
    path2.lineTo(size.width, size.height * 0.7);

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);

    final dotX = (size.width / 6) * selectedIndex;
    canvas.drawCircle(
        Offset(dotX, size.height * 0.3), 6, Paint()..color = color);
    canvas.drawCircle(Offset(dotX, size.height * 0.3), 3,
        Paint()..color = primaryColor);
  }

  @override
  bool shouldRepaint(covariant WorkoutWavePainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
