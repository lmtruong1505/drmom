import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HospitalFilter extends StatelessWidget {
  const HospitalFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.logo.image(height: 60, width: 60),
        16.height,
        Text(
          "Bệnh viện đa khoa huyện Quốc Oai\nOai", // Checking line break in screenshot
          textAlign: TextAlign.center,
          style: AppTypography.h5.copyWith(color: AppColors.black),
        ),
        16.height,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyAA), // Using grey border
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: "Toàn viện",
              items:
                  ["Toàn viện"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (_) {},
              style: AppTypography.p5.copyWith(color: AppColors.black),
            ),
          ),
        ),
      ],
    );
  }
}
