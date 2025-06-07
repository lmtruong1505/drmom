import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/home/data/model/product_model_v2.dart';

part 'product_warehouse_model.freezed.dart';
part 'product_warehouse_model.g.dart';

@freezed
class ProductWarehouseModel with _$ProductWarehouseModel {
  const factory ProductWarehouseModel({
    @JsonKey(name: 'shop_name') final String? shopName,
    final List<ProductModelV2>? items,
    @Default(false) final bool? isSelect,
  }) = _ProductWarehouseModel;

  factory ProductWarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductWarehouseModelFromJson(json);
}
