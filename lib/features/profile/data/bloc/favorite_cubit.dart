import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_cubit.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/features/booth/data/models/booth_model.dart';
import 'package:BGP_Retail/features/home/data/model/product_model.dart';
import 'package:BGP_Retail/features/profile/data/bloc/favorite_state.dart';

@Injectable()
class FavoriteCubit extends BaseCubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState());

  void onChangeTab(int tabActive) {
    emit(state.copyWith(tabActive: tabActive));
  }

  List<ProductModel> get listProductFavorite {
    return preferences.productFavoriteV2;
  }

  List<BoothModel> get listBoothFavorite {
    return preferences.boothFavorite;
  }

  void setFavorites() {
    emit(
      state.copyWith(
        keyword: '',
        products: listProductFavorite,
        booths: listBoothFavorite,
        productsClone: listProductFavorite,
        boothsClone: listBoothFavorite,
      ),
    );
  }

  void setKeyword(String keyword) {
    emit(state.copyWith(keyword: keyword));
  }

  void handleSearchProduct(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      final searchs = state.formulasClone.where((e) {
        final name = removeVietnameseTones(e.formulaName.toLowerCase());
        final keywordRemoveTones = removeVietnameseTones(keyword);
        return name.contains(keywordRemoveTones);
      }).toList();

      emit(state.copyWith(formulas: searchs));
    } else {
      emit(state.copyWith(formulas: state.formulasClone));
    }
    emit(state.copyWith(keyword: keyword));
  }

  void handleSearchBooth(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      final searchs = state.boothsClone.where((e) {
        final name = removeVietnameseTones(e.fullname.toLowerCase());
        final username = removeVietnameseTones(e.username.toLowerCase());
        final keywordRemoveTones = removeVietnameseTones(keyword);
        return name.contains(keywordRemoveTones) ||
            username.contains(keywordRemoveTones);
      }).toList();

      emit(state.copyWith(booths: searchs));
    } else {
      emit(state.copyWith(booths: state.boothsClone));
    }
    emit(state.copyWith(keyword: keyword));
  }

  void removeBoothFavorite(BoothModel booth) {
    final List<BoothModel> boothFavorite = preferences.boothFavorite;

    final index = boothFavorite.indexWhere(
      (e) => e.id == booth.id,
    );

    if (index != -1) {
      boothFavorite.removeAt(index);
    }

    preferences.saveBoothFavorite(jsonEncode(boothFavorite));
    setFavorites();
  }

  void removeProductFavorite(ProductModel product) {
    final List<ProductModel> productFavorite = preferences.productFavoriteV2;

    final index = productFavorite.indexWhere(
      (e) => e.id == product.id,
    );

    if (index != -1) {
      productFavorite.removeAt(index);
    }

    preferences.saveProductFavoriteV2(jsonEncode(productFavorite));
    setFavorites();
  }
}
