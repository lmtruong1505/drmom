import 'package:flutter/material.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";

class CameraFloatButton extends StatelessWidget {
  final Function() onPressed;
  const CameraFloatButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.grey_79,
      splashColor: AppColors.grey_79,
      hoverElevation: 1.5,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.white, width: 5),
      ),
      onPressed: () {
        onPressed.call();
      },
    );
  }
}
