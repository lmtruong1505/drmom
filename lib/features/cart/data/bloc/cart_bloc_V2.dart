import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/cart/data/models/product_warehouse_model.dart';
import 'package:bpg_retail/features/cart/data/repositories/cart_repository.dart';

import '../../../../core/base/cubit_state.dart';
import '../../../home/data/model/product_model_v2.dart';

@LazySingleton()
class CartV2Bloc extends Cubit<CubitState> {
  CartV2Bloc(this._repo) : super(CubitState());

  List<ProductWarehouseModel> warehouseProduct = [];
  final CartRepository _repo;

  void getCart() async {
    warehouseProduct.clear();
    try {
      emit(state.copyWith(status: CubitStatus.loadMore));
      final res = await _repo.getCart();
      if (res.code == 200) {
        warehouseProduct.addAll(res.data ?? []);
        emit(state.copyWith(status: CubitStatus.success));
      } else {
        emit(state.copyWith(status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  int get totalPrdsSelect => warehouseProduct
      .expand((warehouse) => warehouse.items ?? [])
      .where((prd) => prd.isSelect == true)
      .length;
  int get cartLength => warehouseProduct.expand((e) => e.items ?? []).length;
  num get totalPrice => warehouseProduct
      .expand((warehouse) => warehouse.items!)
      .where((prd) => prd.isSelect == true)
      .fold(
        0,
        (pre, element) =>
            pre +
            (element.variant?.firstOrNull?.priceSell ?? 0) *
                (element.quantity ?? 0),
      );
  int get indexSelected => warehouseProduct.indexWhere(
        (warehouse) =>
            warehouse.items!.any((product) => product.isSelect == true),
      );
  void onUpdateQuantity(ProductModelV2 cart, num updateQuantity) {
    warehouseProduct = warehouseProduct.map(
      (products) {
        final updatePrds = products.items?.map(
          (product) {
            if (product.id == cart.id) {
              return product.copyWith(quantity: updateQuantity);
            }
            return product;
          },
        ).toList();
        return products.copyWith(items: updatePrds);
      },
    ).toList();
  }

  void onAdd(ProductModelV2 cart) {
    // warehouseProduct = warehouseProduct.map(
    //   (products) {
    //     final updatePrds = products.items?.map(
    //       (product) {
    //         if (product.id == cart.id) {
    //           return product =
    //               product.copyWith(quantity: (product.quantity ?? 0) + 1);
    //         }
    //         return product;
    //       },
    //     ).toList();
    //     return products.copyWith(items: updatePrds);
    //   },
    // ).toList();
    final updateQuantity = (cart.quantity ?? 0) + 1;
    onUpdateQuantity(cart, updateQuantity);
    updatePrd(id: cart.id, quantity: updateQuantity);
    // emit(state.copyWith(status: CubitStatus.success));
  }

  void onMinus(ProductModelV2 cart) {
    // warehouseProduct = warehouseProduct.map(
    //   (products) {
    //     final updatePrds = products.items?.map(
    //       (product) {
    //         if (product.id == cart.id) {
    //           return product.copyWith(quantity: (product.quantity ?? 0) - 1);
    //         }
    //         return product;
    //       },
    //     ).toList();
    //     return products.copyWith(items: updatePrds);
    //   },
    // ).toList();
    final updateQuantity = (cart.quantity ?? 0) - 1;
    onUpdateQuantity(cart, updateQuantity);
    updatePrd(id: cart.id, quantity: updateQuantity);
  }

  void onInput(ProductModelV2 cart, num updateQuantity) {
    onUpdateQuantity(cart, updateQuantity);
    updatePrd(id: cart.id, quantity: updateQuantity);
  }

  void onSelectPrd(ProductModelV2 cart) {
    warehouseProduct = warehouseProduct.map(
      (warehouse) {
        final updatePrds = warehouse.items?.map(
          (product) {
            if (product.id == cart.id) {
              return product.copyWith(isSelect: !(product.isSelect ?? true));
            }
            return product;
          },
        ).toList();
        final isSelectAll =
            updatePrds?.every((e) => e.isSelect == true) ?? false;

        if (isSelectAll) {
          warehouse = warehouse.copyWith(isSelect: true);
        } else {
          warehouse = warehouse.copyWith(isSelect: false);
        }
        return warehouse.copyWith(items: updatePrds);
      },
    ).toList();
    emit(state.copyWith(status: CubitStatus.success));
  }

  void onDeletePrds(List<ProductModelV2> deletePrds) {
    warehouseProduct = warehouseProduct.map(
      (warehouse) {
        final updatePrds = warehouse.items
            ?.where((product) => !deletePrds.contains(product))
            .toList();
        final isSelectAll =
            updatePrds?.every((e) => e.isSelect == true) ?? false;
        if (isSelectAll) {
          warehouse = warehouse.copyWith(isSelect: true);
        } else {
          warehouse = warehouse.copyWith(isSelect: false);
        }
        return warehouse.copyWith(items: updatePrds);
      },
    ).toList();
  }

  void onSelectWarehouse(ProductWarehouseModel warehouseSelect) {
    warehouseProduct = warehouseProduct.map(
      (warehouse) {
        if (warehouseSelect.shopName == warehouse.shopName) {
          final isSelectAll = !(warehouse.isSelect ?? true);
          final updatePrds = warehouse.items
              ?.map((product) => product.copyWith(isSelect: isSelectAll))
              .toList();
          return warehouse.copyWith(
            items: updatePrds,
            isSelect: isSelectAll,
          );
        }
        return warehouse;
      },
    ).toList();
    emit(state.copyWith(status: CubitStatus.success));
  }

  void deletePrds({List<ProductModelV2>? deletePrds}) async {
    try {
      final selectPrds = warehouseProduct
          .expand((warehouse) => warehouse.items!)
          .where((prd) => prd.isSelect == true)
          .toList();

      final deleteIds =
          (deletePrds ?? selectPrds).map((prd) => prd.id ?? 0).toList();

      emit(state.copyWith(status: CubitStatus.loadMore));
      final res = await _repo.deletePrd(ids: deleteIds);

      onDeletePrds(deletePrds ?? selectPrds);
      emit(
        state.copyWith(
          status: res.code == 200 ? CubitStatus.success : CubitStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  void updatePrd({required int? id, required num? quantity}) async {
    try {
      emit(state.copyWith(status: CubitStatus.loadMore));

      final res = await _repo.updatePrd(id: id, quantity: quantity);
      final isSuccess = res.code == 200;
      emit(
        state.copyWith(
          status: isSuccess ? CubitStatus.success : CubitStatus.loaded,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error));
    }
  }
}
