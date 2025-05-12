import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unit_price_model.g.dart';

@JsonSerializable()
class UnitPriceModel {
  @JsonKey(name: 'price_formula_id')
  final int priceFormulaId;
  @JsonKey(name: 'unit_code')
  final String unitCode;
  @JsonKey(name: 'unit_name')
  final String unitName;
  final double price;

  UnitPriceModel({
    required this.priceFormulaId,
    required this.unitCode,
    required this.unitName,
    required this.price,
  });

  factory UnitPriceModel.fromJson(Map<String, dynamic> json) =>
      _$UnitPriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitPriceModelToJson(this);
}
