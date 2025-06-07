import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bpg_retail/features/product/data/models/unit_price_model.dart';

part 'formula_model.g.dart';

@JsonSerializable()
class FormulaModel {
  @JsonKey(name: 'formula_id')
  final int formulaId;
  @JsonKey(name: 'formula_name')
  final String formulaName;
  final String? image;
  @JsonKey(name: 'unit_price')
  final List<UnitPriceModel>? unitPrice;
  final double? rate;
  final double? discount;
  final String? describe;
  final double? sell;
  final int? quantity;

  FormulaModel({
    required this.formulaId,
    required this.formulaName,
    this.image,
    this.unitPrice,
    this.rate,
    this.discount,
    this.describe,
    this.sell,
    this.quantity,
  });

  factory FormulaModel.fromJson(Map<String, dynamic> json) =>
      _$FormulaModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormulaModelToJson(this);

  FormulaModel copyWith({
    int? formulaId,
    String? formulaName,
    String? image,
    List<UnitPriceModel>? unitPrice,
    double? rate,
    double? discount,
    String? describe,
    double? sell,
    int? quantity,
  }) {
    return FormulaModel(
      formulaId: formulaId ?? this.formulaId,
      formulaName: formulaName ?? this.formulaName,
      image: image ?? this.image,
      unitPrice: unitPrice ?? this.unitPrice,
      rate: rate ?? this.rate,
      discount: discount ?? this.discount,
      describe: describe ?? this.describe,
      sell: sell ?? this.sell,
      quantity: quantity ?? this.quantity,
    );
  }
}

@JsonSerializable()
class FormulaRatingModel {
  final double star;
  @JsonKey(name: 'formula_id')
  final int formulaId;
  final String comment;
  @JsonKey(name: 'object_account')
  final dynamic objectAccount;
  @JsonKey(name: 'created_at')
  final String createdAt;

  FormulaRatingModel({
    required this.star,
    required this.formulaId,
    required this.comment,
    required this.objectAccount,
    required this.createdAt,
  });

  factory FormulaRatingModel.fromJson(Map<String, dynamic> json) =>
      _$FormulaRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormulaRatingModelToJson(this);

  FormulaRatingModel copyWith({
    double? star,
    int? formulaId,
    String? comment,
    String? createdAt,
    dynamic objectAccount,
  }) {
    return FormulaRatingModel(
      star: star ?? this.star,
      formulaId: formulaId ?? this.formulaId,
      comment: comment ?? this.comment,
      objectAccount: objectAccount ?? this.objectAccount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
