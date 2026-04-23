import 'dart:math';

import 'package:flutter/rendering.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";

bool areListsEqual(List<int>? list1, List<int>? list2) {
  if (list1 == null || list2 == null) return false;
  if (list1.length != list2.length) return false;

  final set1 = list1.toSet();
  final set2 = list2.toSet();
  return set1.difference(set2).isEmpty && set2.difference(set1).isEmpty;
}

Color getColorStatusV0(int statusCode) {
  if (statusCode == 1) {
    return AppColors.yellow_f0;
  }

  if (statusCode == 2) {
    return AppColors.blue_1;
  }

  if (statusCode == 3) {
    return AppColors.blue_1;
  }
  if (statusCode == 4) {
    return AppColors.yellow_f0;
  }

  if (statusCode == 5) {
    return AppColors.blue_1;
  }

  if (statusCode == 6) {
    return AppColors.red;
  }
  return AppColors.yellow_f0;
}

Color getColorStatusBackgroundV0(String statusCode) {
  if (statusCode == "CTT") {
    return AppColors.yellow_2;
  }
  if (statusCode == "ĐHT") {
    return AppColors.accent_3;
  }
  if (statusCode == "ĐH") {
    return AppColors.red_2;
  }

  return AppColors.yellow_2;
}

double calculateDistance(num lat1, num lon1, num lat2, num lon2) {
  const p = 0.017453292519943295;
  const c = cos;
  final a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
