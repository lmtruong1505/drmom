import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/constants/preference_keys.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/base/cubit_state.dart';
import '../../../home/data/model/product_model_v2.dart';

class CartBloc extends Cubit<CubitState> {
  CartBloc() : super(CubitState());

  final List<ProductModelV2> carts = [];

  getCart() async {
    carts.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final prds = prefs.getString("${PrefKeys.cart}_abc") ?? '[]';
    final map = jsonDecode(prds);
    for (final json in map) {
      carts.add(ProductModelV2.fromJson(json));
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  addCart(ProductModelV2 prd) async {
    final bool isAdd = carts
        .where(
          (element) =>
              element.id == prd.id &&
              element.optionCart
                      ?.map(
                        (e) => e.id,
                      )
                      .toString() ==
                  prd.optionCart
                      ?.map(
                        (e) => e.id,
                      )
                      .toString(),
        )
        .isEmpty;
    if (isAdd) {
      carts.add(prd);
      saveCart();
    }

    emit(state.copyWith(status: CubitStatus.success));
  }

  delete(int index) async {
    carts.removeAt(index);

    saveCart();

    emit(state.copyWith(status: CubitStatus.success));
  }

  saveCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final map = carts.map(
      (e) {
        final json = <String, dynamic>{
          "id": e.id,
          "title": e.title,
          "code": e.code,
          "price_sell": e.priceSell,
          'quantity': e.quantity,
          'options_cart': e.optionCart
              ?.map(
                (option) => {
                  "id": option.id,
                  "title": option.title,
                  "type": option.type,
                  "values": option.values,
                  "status": option.status,
                },
              )
              .toList(),
          "media_data": e.mediaData
              ?.map(
                (image) => {
                  "id": image.id,
                  "alt": image.alt,
                  "image": image.image,
                },
              )
              .toList(),
          "company_data": {
            "id": e.companyData?.id,
            "title": e.companyData?.title,
            "address_data": e.companyData?.address,
            "phone": e.companyData?.phone,
          },
        };
        json.removeWhere(
          (key, value) => value == null,
        );
        return json;
      },
    ).toList();
    print(map);
    final data = jsonEncode(
      map,
    );
    prefs.setString("${PrefKeys.cart}_abc", data);
  }
}
