import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/booth/data/repositories/booth_repository.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/features/order/data/repositories/order_repository.dart';
import 'package:bpg_retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:bpg_retail/features/profile/data/repositories/address_repository.dart';

import '../models/delivery_price_model.dart';
import 'cart_state.dart';

@LazySingleton()
class CartCubit extends BaseCubit<CartState> {
  CartCubit(
    this._orderRepository,
    this._boothRepository,
    // this._addressRepository,
    this._notiCubit,
  ) : super(const CartState());

  final OrderRepository _orderRepository;
  final BoothRepository _boothRepository;
  // final AddressRepository _addressRepository;
  final NotificationCubit _notiCubit;

  void changeOrderPayload(OrderPayloadModel orderPayload) {
    emit(
      state.copyWith(
        orderPayload: orderPayload.copyWith(
          customerInfo: state.addressSelected?.toJson(),
        ),
      ),
    );
  }

  void setAddressSelected(AddressModel addressSelected) {
    emit(state.copyWith(addressSelected: addressSelected));
    changeOrderPayload(
      state.orderPayload!.copyWith(
        address: addressSelected.address['text'],
        customerInfo: addressSelected.toJson(),
      ),
    );
  }

  void setBoothSelected(BoothModel boothSelected) {
    emit(state.copyWith(boothSelected: boothSelected));
    changeOrderPayload(
      state.orderPayload!.copyWith(
        groceryId: boothSelected.id,
      ),
    );
  }

  void deliverySelectHandle(DeliveryType value) {
    if (value == DeliveryType.pickUp) {
      priceDeliveryHandle(null);
    }
    emit(state.copyWith(deliverySelected: value));
  }

  void priceDeliveryHandle(DeliveryPriceModel? value) {
    emit(state.copyWith(priceSelected: value));
  }

  // void createOrder({bool? isCart = false}) async {
  //   emit(state.copyWith(isLoading: true));
  //   EasyLoading.show();
  //   try {
  //     final payload = state.orderPayload!.copyWith(
  //       totalPrice: state.orderPayload?.totalPrice ?? 0,
  //       totalDeliveryCost: (state.priceSelected?.giaCuoc ?? 0).toDouble(),
  //     );
  //     final res = await _orderRepository.orderCreate(payload);
  //     EasyLoading.dismiss();
  //     emit(state.copyWith(isLoading: false));
  //     res.fold(
  //       (l) {
  //         navigator.showAppTopSnackBar(
  //           l["message"] ?? 'Có lỗi xảy ra!',
  //           type: 'error',
  //         );
  //         emit(state.copyWith(isLoading: false));
  //         EasyLoading.dismiss();
  //       },
  //       (r) {
  //         if (isCart == true) {
  //           appCubit.upgradeCart(
  //             appCubit.state.cartList
  //                 .where((e) => e.isChecked == false)
  //                 .toList(),
  //           );
  //           navigator.popUntilRoot(useRootNavigator: true);
  //           navigator.push(const CartPage());
  //         } else {
  //           navigator.back();
  //           navigator.back();
  //         }

  //         final Map<String, dynamic> dataNotify = {
  //           "module": ModuleEnum.TM_ORDER.title,
  //           "custom_id": r["data"]["order_id"],
  //           "status": false,
  //           "title": "Đơn hàng mới từ hệ thống TMĐT",
  //           "content":
  //               "Đơn hàng mới ${r['data']['order_code']} từ hệ thống TMĐT. Vui lòng kiểm tra thông tin chi tiết",
  //           "data": '',
  //           "user_created": preferences.currentUser.user!.id,
  //           "user_updated": preferences.currentUser.user!.id,
  //           "is_failed": false,
  //         };

  //         _notiCubit.createNoti(
  //           dataNotify: dataNotify,
  //           listUser: [state.orderPayload!.groceryId],
  //         );

  //         showOverlayNotification(
  //           (context) {
  //             return SafeArea(
  //               child: GestureDetector(
  //                 onTap: () {
  //                   OverlaySupportEntry.of(context)?.dismiss();
  //                 },
  //                 child: Card(
  //                   child: ListTile(
  //                     leading: SizedBox.fromSize(
  //                       size: const Size(40, 40),
  //                       child: ClipOval(
  //                         child: Container(
  //                           color: AppColors.green_2,
  //                           child: const Icon(
  //                             Icons.shopping_bag,
  //                             color: AppColors.green_1,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     title: const Text(
  //                       'Đặt hàng thành công',
  //                     ),
  //                     subtitle: const Text(
  //                       'Cảm ơn bạn đã đặt hàng.',
  //                     ),
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       vertical: 6,
  //                       horizontal: 16,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           duration: const Duration(milliseconds: 4000),
  //         );

  //         emit(state.copyWith(isLoading: false));
  //       },
  //     );
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }

  double get getLat {
    return preferences.locations.length > 1 ? preferences.locations[0] : 0;
  }

  double get getLong {
    return preferences.locations.length > 1 ? preferences.locations[1] : 0;
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

  // void shopList({
  //   String? keyword,
  //   bool? isEmpty,
  // }) async {
  //   if (isEmpty == false && keyword!.isEmpty) {
  //     emit(state.copyWith(booths: []));
  //     return;
  //   }
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
  //       keyword: keyword,
  //       page: 0,
  //       pageSize: 5,
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
  //         emit(state.copyWith(booths: booths));
  //       },
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<bool> getListAddress() async {
  //   bool isSuccess = false;
  //   showLoading();
  //   emit(state.copyWith(isLoading: true));
  //   final res = await _addressRepository.getListAddress();
  //   emit(state.copyWith(isLoading: false));

  //   res.fold((l) => {}, (r) {
  //     appCubit.setAddressList(
  //       (r['data'] as List<dynamic>)
  //           .map(
  //             (e) => AddressModel.fromJson(e),
  //           )
  //           .toList(),
  //     );
  //     isSuccess = r['data'].length > 0;
  //     EasyLoading.dismiss();
  //   });
  //   EasyLoading.dismiss();
  //   return isSuccess;
  // }
}
