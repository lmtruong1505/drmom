import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';

class BtnIcon extends StatelessWidget {
  final double radius;
  final Widget icon;
  final Function()? onTap;
  final Size? size;
  final Color? borderColor;
  final Color? color;
  const BtnIcon({
    super.key,
    required this.icon,
    this.radius = 8,
    this.onTap,
    this.size,
    this.borderColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size?.width,
        height: size?.height,
        // clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border:
              Border.all(color: borderColor ?? color ?? Colors.white, width: 0),
          color: color ?? Colors.white,
          borderRadius: radius.radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}
