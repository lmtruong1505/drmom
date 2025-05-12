import 'package:flutter/material.dart';

class SliverPersistentHeaderCustom extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHight;

  SliverPersistentHeaderCustom({
    required this.child,
    required this.maxHeight,
    required this.minHight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
