import 'dart:math';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:flutter/material.dart';

class DepreciationChartWidget extends StatelessWidget {
  const DepreciationChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng hao mòn",
                    style: AppTypography.p7.copyWith(color: AppColors.grey79),
                  ),
                  4.height,
                  Text("136.458.123 đ", style: AppTypography.h5),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Còn lại",
                    style: AppTypography.p7.copyWith(color: AppColors.red),
                  ),
                  4.height,
                  Text("229.293.236 đ", style: AppTypography.h5),
                ],
              ),
            ],
          ),
          24.height,
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: GaugeChartPainter(percentage: 0.77), // 77%
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    left: 40,
                    bottom: 20,
                    child: Text("23%", style: AppTypography.h2),
                  ),
                  Positioned(
                    right: 40,
                    bottom: 20,
                    child: Text(
                      "77%",
                      style: AppTypography.h2.copyWith(color: AppColors.grey_1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double percentage;

  GaugeChartPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width / 2, size.height) - 10;
    const strokeWidth = 20.0;

    final paintBg =
        Paint()
          ..color = AppColors.blue_2.withOpacity(0.5) // Light background
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final paintValue =
        Paint()
          ..color = Color(0xFF4C3AE3) // Purple
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Background Arc (180 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      paintBg,
    );

    // Value Arc (Percentage)
    // Needs to start from left (pi) and go clockwise
    // Wait, the screenshot shows Blue (23%) on Left and Light Grey (77%) on right?
    // Let's look at Screenshot 1.
    // The gauge is Blue on the LEFT (approx 40%?) and White/Grey on the RIGHT.
    // Knob is at the end of the Blue arc.
    // Text says "23%" (Left) and "77%" (Right).
    // The Blue Arc corresponds to '23%'?
    // The value 23% looks like it covers about 45 degrees of the 180.
    // (0.23 * pi) = 0.72 rad.

    final sweepAngle = pi * 0.23; // 23%

    paintValue.color = Color(0xFF4C3AE3); // Blue-ish Purple
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      paintValue,
    );

    // Draw Knob (Circle at the end of arc)
    final knobAngle = pi + sweepAngle;
    final knobCenter = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );

    final knobPaint = Paint()..color = Color(0xFF4C3AE3);
    canvas.drawCircle(knobCenter, strokeWidth / 1.5, knobPaint);

    // Internal white dot in knob
    canvas.drawCircle(
      knobCenter,
      strokeWidth / 3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
