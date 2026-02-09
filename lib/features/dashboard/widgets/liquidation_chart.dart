import 'dart:math';

import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:flutter/material.dart';

class LiquidationChartWidget extends StatelessWidget {
  const LiquidationChartWidget({super.key});

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
                    "Số lượng đã thanh lý",
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                  4.height,
                  Text("567", style: AppTypography.h5),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Giá trị thanh lý",
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                  4.height,
                  Text("229.293.236 đ", style: AppTypography.h5),
                ],
              ),
            ],
          ),
          24.height,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      sections: [
                        PieSection(value: 85, color: const Color(0xFF4C3AE3)),
                        PieSection(value: 15, color: const Color(0xFFC4C4F4)),
                      ],
                    ),
                  ),
                ),
              ),
              16.width,
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildLegendItem(
                      "Thanh lý khi còn khấu hao",
                      "2.811 (15%)",
                      const Color(0xFFC4C4F4),
                    ),
                    12.height,
                    _buildLegendItem(
                      "Thanh lý khi hết khấu hao",
                      "4.123 (75%)",
                      const Color(0xFF4C3AE3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, String value, Color color) {
    return BaseContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      color: const Color(0xFF7E52FF),
      child: Column(
        children: [
          Text(
            title,
            style: AppTypography.p7.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          4.height,
          Text(value, style: AppTypography.h6.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class PieSection {
  final double value;
  final Color color;
  PieSection({required this.value, required this.color});
}

class PieChartPainter extends CustomPainter {
  final List<PieSection> sections;

  PieChartPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    double startAngle = -pi / 2;
    final total = sections.fold(0.0, (sum, item) => sum + item.value);

    for (var section in sections) {
      final sweepAngle = (section.value / total) * 2 * pi;
      final paint =
          Paint()
            ..color = section.color
            ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
