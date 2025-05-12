import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:BGP_Retail/features/product/data/models/formula_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final int priceFormulaId;
  final bool isChecked;
  final FormulaModel formula;
  final int quantity;
  final double price;

  CartModel({
    required this.priceFormulaId,
    required this.isChecked,
    required this.formula,
    required this.quantity,
    required this.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartModel copyWith({
    int? priceFormulaId,
    bool? isChecked,
    FormulaModel? formula,
    int? quantity,
    double? price,
  }) {
    return CartModel(
      priceFormulaId: priceFormulaId ?? this.priceFormulaId,
      isChecked: isChecked ?? this.isChecked,
      formula: formula ?? this.formula,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
