import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/features/booth/data/models/asbc_both_v2_model.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/booth/data/repositories/booth_repository.dart';

import 'booth_state.dart';

@Injectable()
class BoothCubit extends BaseCubit<BoothState> {
  BoothCubit(this._boothRepository) : super(const BoothState());

  final BoothRepository _boothRepository;

  List<BoothModel> get listBoothFavorite {
    return preferences.boothFavorite;
  }

  void setFavorites() {
    emit(state.copyWith(favorites: listBoothFavorite));
  }

  void setIsFavorite(BoothModel booth) {
    final favorites = [...state.favorites];
    final index = state.favorites.indexWhere((e) => e.id == booth.id);
    if (index == -1) {
      favorites.add(booth);
      navigator.showSuccessSnackBar(
        "Đã thêm vào danh sách yêu thích",
        duration: const Duration(seconds: 1),
      );
    } else {
      favorites.removeAt(index);
      navigator.showSuccessSnackBar(
        "Đã xóa khỏi danh sách yêu thích",
        duration: const Duration(seconds: 1),
      );
    }
    emit(state.copyWith(favorites: favorites));
  }

  Future<List<double>> getLatLngFromAddress(String address) async {
    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return [
          locations.first.latitude,
          locations.first.longitude,
        ];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  double get getLat {
    return preferences.locations.length > 1 ? preferences.locations[0] : 0;
  }

  double get getLong {
    return preferences.locations.length > 1 ? preferences.locations[1] : 0;
  }

  // Future<Map<String, dynamic>> shopList({
  //   int page = 0,
  //   int? pageSize = 10,
  //   int? filtered,
  //   String? keyword,
  //   String? address,
  // }) async {
  //   Map<String, dynamic> results = {"results": [], "total": 0};
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final addressDefault = appCubit.state.addressList.firstWhere(
  //       (e) => e.isDefault == true,
  //       orElse: () => AddressModel(),
  //     );

  //     double latitude = getLat;
  //     double longitude = getLong;

  //     if (addressDefault.address != null) {
  //       final locations = await getLatLngFromAddress(
  //         addressDefault.address['text'],
  //       );
  //       if (locations.length > 1 && locations.every((e) => e != 0)) {
  //         latitude = locations.length > 1 ? locations[0] : getLat;
  //         longitude = locations.length > 1 ? locations[1] : getLong;
  //       }
  //     }

  //     final res = await _boothRepository.shopList(
  //       filtered: filtered,
  //       keyword: keyword,
  //       address: address,
  //       page: page,
  //       pageSize: pageSize,
  //       latitude: latitude,
  //       longitude: longitude,
  //     );
  //     res.fold(
  //       (l) {
  //         emit(state.copyWith(isLoading: false));
  //         // navigator.showAppTopSnackBar(
  //         //   l["message"] ?? 'Có lỗi xảy ra!',
  //         //   type: 'error',
  //         // );
  //       },
  //       (r) {
  //         final booths = (r["data"]["results"] as List<dynamic>).map((e) {
  //           e['total_product'] = appCubit.state.formulas.length;
  //           return BoothModel.fromJson(e);
  //         }).toList();
  //         results = {
  //           "results": booths,
  //           "total": r["data"]["total"],
  //         };
  //         if (filtered != null || keyword != null || address != null) {
  //           appCubit.setBooth([]);
  //         } else {
  //           if (booths.isNotEmpty) {
  //             appCubit.setBoothSelected(booths[0]);
  //           }
  //           appCubit.setBooth(booths);
  //         }
  //         emit(state.copyWith(isLoading: false));
  //       },
  //     );
  //   } catch (e) {
  //     emit(state.copyWith(isLoading: false));
  //   }
  //   emit(state.copyWith(isLoading: false));
  //   return results;
  // }

  void handleSearch(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      final searchs = appCubit.state.formulas.where((e) {
        final name = removeVietnameseTones(e.formulaName.toLowerCase());
        final keywordRemoveTones = removeVietnameseTones(keyword);
        return name.contains(keywordRemoveTones);
      }).toList();

      emit(state.copyWith(formulas: searchs));
    } else {
      emit(state.copyWith(formulas: appCubit.state.formulas));
    }
  }

  void handleSearchCategories(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      final searchs = appCubit.state.categories.where((e) {
        final name = removeVietnameseTones(e.categoryName!.toLowerCase());
        final keywordRemoveTones = removeVietnameseTones(keyword);
        return name.contains(keywordRemoveTones);
      }).toList();

      emit(state.copyWith(categories: searchs));
    } else {
      emit(state.copyWith(categories: appCubit.state.categories));
    }
  }

  void setTop(bool isTop) {
    emit(state.copyWith(isTop: isTop));
  }

  void setFormulas() {
    emit(
      state.copyWith(
        formulas: appCubit.state.formulas,
        categories: appCubit.state.categories,
      ),
    );
  }

  void saveViewedBooths(BoothModel booth) {
    final booths = [...preferences.viewedBooths];
    final index = booths.indexWhere((e) => e.id == booth.id);
    if (index == -1) {
      booths.add(booth);
    }
    preferences.saveViewedBooths(jsonEncode(booths.reversed.toList()));
  }

  List<BoothModel> handleSearchBoothViewed(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      final searchs = preferences.viewedBooths.where((e) {
        final fullname = removeVietnameseTones(e.fullname.toLowerCase());
        final username = removeVietnameseTones(e.username.toLowerCase());
        final address = removeVietnameseTones((e.address ?? '').toLowerCase());
        final keywordRemoveTones = removeVietnameseTones(keyword);
        return fullname.contains(keywordRemoveTones) ||
            username.contains(keywordRemoveTones) ||
            address.contains(keywordRemoveTones);
      }).toList();

      return searchs;
    }
    return preferences.viewedBooths;
  }

  AbbcBothV2Model? both;
  void getBoth(int id) async {
    emit(state.copyWith(isLoading: true));
    final res = await _boothRepository.getBoth(id);
    if (res.code == 200) {
      both = res.data;
      emit(state.copyWith(isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }
}
