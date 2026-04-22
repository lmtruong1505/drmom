import 'dart:math';

import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import "package:bpg_retail/core/configs/app_style/init_app_style.dart";
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:flutter/material.dart';

class DepreciationChartWidget extends StatelessWidget {
  const DepreciationChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
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
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
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
                    style: AppTypography.p7.copyWith(color: AppColors.red60),
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
              painter: GaugeChartPainter(percentage: 0.77),
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
                      style: AppTypography.h2.copyWith(
                        color: AppColors.text_tertiary,
                      ),
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
          ..color = AppColors.blue20.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final paintValue =
        Paint()
          ..color = const Color(0xFF4C3AE3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      paintBg,
    );

    final sweepAngle = pi * 0.23;

    paintValue.color = const Color(0xFF4C3AE3);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      paintValue,
    );

    final knobAngle = pi + sweepAngle;
    final knobCenter = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );

    final knobPaint = Paint()..color = const Color(0xFF4C3AE3);
    canvas.drawCircle(knobCenter, strokeWidth / 1.5, knobPaint);

    canvas.drawCircle(
      knobCenter,
      strokeWidth / 3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
