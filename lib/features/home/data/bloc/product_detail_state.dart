import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/home/data/model/product_model_v2.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  factory ProductDetailState({
    @Default(CubitStatus.init) CubitStatus status,
    @Default(null) ProductModelV2? product,
    Map<String, OptionData>? optionSelect,
    @Default(false) bool isFavorite,
    @Default(0) int tabIndex,
    int? indexSelected,
  }) = _ProductDetailPageState;
}
