// lib/features/wellness/widgets/compare_results/weight_trend_chart.dart
import 'package:flutter/material.dart';
import '../../screens/progress_photo.dart';

class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart(
      {super.key, required this.history, required this.monthNames});
  final List<ProgressSession> history;
  final List<String> monthNames;

  static const Color rowBg = Color(0xFFF4F5F7);
  static const Color darkText = Color(0xFF1E1B2E);
  static const Color greyText = Color(0xFF9C99AC);
  static const Color goodGreen = Color(0xFF34C759);
  static const Color warnAmber = Color(0xFFE0A030);

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: rowBg, borderRadius: BorderRadius.circular(16)),
        child: const Column(
          children: [
            Icon(Icons.show_chart, color: greyText, size: 28),
            SizedBox(height: 8),
            Text('No weight trend yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            SizedBox(height: 4),
            Text(
              'Log your weight on at least 2 days from the Progress Photo screen to see a chart here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: greyText, fontSize: 11),
            ),
          ],
        ),
      );
    }

    final first = history.first.weightKg!;
    final last = history.last.weightKg!;
    final change = last - first;
    final pct = first == 0 ? 0.0 : (change / first) * 100;
    final isDown = change <= 0;

    return SizedBox(
      height: 190,
      width: double.infinity,
      child: Stack(
        children: [
          CustomPaint(
              size: const Size(double.infinity, 150),
              painter: _WeightTrendPainter(
                  history: history, monthNames: monthNames)),
          Positioned(
            top: 8,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8)
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isDown ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDown ? goodGreen : warnAmber, size: 12),
                  const SizedBox(width: 4),
                  Text(
                      '${pct.abs().toStringAsFixed(1)}% weight ${isDown ? 'down' : 'up'}',
                      style: TextStyle(
                          color: isDown ? goodGreen : warnAmber,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightTrendPainter extends CustomPainter {
  _WeightTrendPainter({required this.history, required this.monthNames});
  final List<ProgressSession> history;
  final List<String> monthNames;

  static const Color primaryBlue = Color(0xFF96B1FE);
  static const Color accentPurple = Color(0xFF8C93F5);
  static const Color greyText = Color(0xFF9C99AC);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 8.0;
    const rightPad = 46.0;
    const bottomPad = 22.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - bottomPad;

    final weights = history.map((s) => s.weightKg!).toList();
    var minW = weights.reduce((a, b) => a < b ? a : b);
    var maxW = weights.reduce((a, b) => a > b ? a : b);
    if (minW == maxW) {
      minW -= 1;
      maxW += 1;
    }
    final padded = (maxW - minW) * 0.2;
    minW -= padded;
    maxW += padded;

    final gridPaint = Paint()
      ..color = const Color(0xFFEDEDF2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(
          Offset(leftPad, y), Offset(leftPad + chartWidth, y), gridPaint);
      final value = maxW - (maxW - minW) * (i / 4);
      final tp = TextPainter(
        text: TextSpan(
            text: '${value.toStringAsFixed(0)}kg',
            style: const TextStyle(color: greyText, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad + chartWidth + 6, y - 5));
    }

    final dx = history.length > 1 ? chartWidth / (history.length - 1) : 0.0;
    final path = Path();
    final points = <Offset>[];
    for (int i = 0; i < history.length; i++) {
      final x = leftPad + dx * i;
      final w = history[i].weightKg!;
      final y = chartHeight * (1 - (w - minW) / (maxW - minW));
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prev = points[i - 1];
        final ctrlX = (prev.dx + x) / 2;
        path.cubicTo(ctrlX, prev.dy, ctrlX, y, x, y);
      }
    }

    canvas.drawPath(
        path,
        Paint()
          ..color = primaryBlue
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke);

    final dotPaint = Paint()..color = accentPurple;
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }

    for (int i = 0; i < history.length; i++) {
      final x = leftPad + dx * i;
      final d = history[i].date;
      final label = '${d.day} ${monthNames[d.month - 1].substring(0, 3)}';
      final tp = TextPainter(
        text: TextSpan(
            text: label, style: const TextStyle(color: greyText, fontSize: 9)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) =>
      oldDelegate.history != history;
}
