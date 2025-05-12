import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';

class RowItem extends StatelessWidget {
  const RowItem({
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
        Text(title, style: titleStyle ?? s12w400),
        12.width,
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              subtitle,
              style: subStyle ?? s12w400,
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
