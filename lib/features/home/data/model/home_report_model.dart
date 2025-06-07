import 'package:json_annotation/json_annotation.dart';

part 'home_report_model.g.dart';

@JsonSerializable()
class ReportHomeModel {
  ReportHomeModel({
    this.warehouse,
    this.invoice,
    this.actualBalance,
    this.openBalance,
    this.details,
  });

  final String? warehouse;
  final num? invoice;

  @JsonKey(name: 'actual_balance')
  final num? actualBalance;

  @JsonKey(name: 'open_balance')
  final num? openBalance;
  final Map<String, Detail>? details;

  factory ReportHomeModel.fromJson(Map<String, dynamic> json) =>
      _$ReportHomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportHomeModelToJson(this);
}

@JsonSerializable()
class Detail {
  Detail({
    this.stock,
    this.price,
    this.totalPrice,
    this.productData,
  });

  final num? stock;
  final num? price;

  @JsonKey(name: 'total_price')
  final num? totalPrice;

  @JsonKey(name: 'product_data')
  final ProductData? productData;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class ProductData {
  ProductData({
    this.id,
    this.productName,
    this.productCode,
    this.productFile,
  });

  final int? id;

  @JsonKey(name: 'product_name')
  final String? productName;

  @JsonKey(name: 'product_code')
  final String? productCode;

  @JsonKey(name: 'product_file')
  final ProductFile? productFile;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}

@JsonSerializable()
class ProductFile {
  ProductFile({
    this.id,
    this.productId,
    this.imageData,
  });

  final int? id;

  @JsonKey(name: 'product_id')
  final int? productId;

  @JsonKey(name: 'image_data')
  final String? imageData;

  factory ProductFile.fromJson(Map<String, dynamic> json) =>
      _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);
}
