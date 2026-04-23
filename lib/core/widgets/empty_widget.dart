import 'package:flutter/material.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.title,
  });
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title ?? "Chưa có sản phẩm",
        style: AppTypography.p3,
      ),
    );
  }
}
