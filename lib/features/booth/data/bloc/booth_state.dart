import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/features/booth/data/models/booth_model.dart';
import 'package:BGP_Retail/features/product/data/models/category_model.dart';
import 'package:BGP_Retail/features/product/data/models/formula_model.dart';

part 'booth_state.freezed.dart';

@freezed
class BoothState with _$BoothState {
  const factory BoothState({
    @Default(false) bool isTop,
    @Default(false) bool isLoading,
    @Default([]) List<BoothModel> favorites,
    @Default([]) List<BoothModel> shopList,
    @Default([]) List<FormulaModel> formulas,
    @Default([]) List<CategoryModel> categories,
    @Default(AddressSelectionModel())
    AddressSelectionModel addressSelectionModel,
    @Default(FilterButtonModel(title: "Tất cả", value: null))
    FilterButtonModel selectFilter,
  }) = _BoothState;
}
