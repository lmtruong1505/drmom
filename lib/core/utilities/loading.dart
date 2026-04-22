import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:bpg_retail/core/configs/app_style/init_app_style.dart";

void showLoading() {
  EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.black);
}

Future<bool?> showToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.blackish,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
