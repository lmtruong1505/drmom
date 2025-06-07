import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/home/data/model/product_model.dart';
import 'package:bpg_retail/features/product/data/models/formula_model.dart';

part 'favorite_state.freezed.dart';

@freezed
class FavoriteState with _$FavoriteState {
  const factory FavoriteState({
    @Default(0) int tabActive,
    @Default('') String keyword,
    @Default([]) List<FormulaModel> formulas,
    @Default([]) List<BoothModel> booths,
    @Default([]) List<FormulaModel> formulasClone,
    @Default([]) List<BoothModel> boothsClone,
    @Default([]) List<ProductModel> products,
    @Default([]) List<ProductModel> productsClone,
  }) = _FavoriteState;
}
