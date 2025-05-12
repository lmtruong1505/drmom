import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardWalletModel {
  String title;
  double? balance;
  double opacity;
  int? type;
  double? percentWithdraw;
  double? percentShopping;
  List<Color> colors;
  String? textBtn;
  String? subTitle;
  Function()? onTap;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastScanAt;
  double? totalCashback;
  Widget? logo;

  CardWalletModel({
    required this.title,
    this.balance,
    required this.opacity,
    required this.colors,
    this.textBtn,
    this.onTap,
    this.subTitle,
    this.type,
    this.percentWithdraw,
    this.percentShopping,
    this.createdAt,
    this.updatedAt,
    this.totalCashback,
    this.logo,
    this.lastScanAt,
  });

  factory CardWalletModel.formJson(Map<String, dynamic> json) {
    return CardWalletModel(
      title: json['title'],
      balance: double.tryParse(json['balance'].toString()),
      totalCashback: double.tryParse(json['total_cashback'].toString()),
      type: int.tryParse(json['type'].toString()),
      percentShopping: json['config'] != null
          ? double.tryParse(json['config']['percent_shopping'].toString())
          : null,
      percentWithdraw: json['config'] != null
          ? double.tryParse(json['config']['percent_withdraw'].toString())
          : null,
      colors: [],
      opacity: 0.6,
      createdAt: DateTime.tryParse(json['created_at'].toString()),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()),
      lastScanAt: DateTime.tryParse(json['last_scan_at'].toString()),
    );
  }
}
