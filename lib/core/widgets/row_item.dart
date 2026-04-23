import 'package:flutter/material.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import 'package:drmom/core/extension/spacing_extension.dart';

class BaseRowItem extends StatelessWidget {
  const BaseRowItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.subStyle,
    this.titleStyle,
    this.maxLines,
  });
  final String title;
  final String subtitle;
  final TextStyle? subStyle;
  final TextStyle? titleStyle;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle ?? AppTypography.p9),
        12.width,
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              subtitle,
              style: subStyle ?? AppTypography.p9,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
