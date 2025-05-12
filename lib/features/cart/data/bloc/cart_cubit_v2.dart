import 'package:dartx/dartx.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/core/configs/enums/noti_enum.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/dropdown_button.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/booth/data/models/booth_model.dart';
import 'package:BGP_Retail/features/booth/data/repositories/booth_repository.dart';
import 'package:BGP_Retail/features/cart/data/bloc/cart_state_v2.dart';
import 'package:BGP_Retail/features/cart/data/models/cart_model_v2.dart';
import 'package:BGP_Retail/features/cart/data/models/delivery_model.dart';
import 'package:BGP_Retail/features/cart/data/repositories/cart_repository.dart';
import 'package:BGP_Retail/features/cart/presentation/widgets/cart_select_booth.dart';
import 'package:BGP_Retail/features/home/data/model/product_model_v2.dart';
import 'package:BGP_Retail/features/order/data/models/order_model.dart';
import 'package:BGP_Retail/features/order/data/repositories/order_repository.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:BGP_Retail/features/profile/data/models/address_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/address_repository.dart';

import '../models/delivery_price_model.dart';

@LazySingleton()
class CartCubitV2 extends Cubit<CartStateV2> {
  final OrderRepository _orderRepository;
  final BoothRepository _boothRepository;
  final AddressRepository _addressRepository;
  final NotificationCubit _notiCubit;
  final CartRepository _cartRepository;

  CartCubitV2(
    this._orderRepository,
    this._boothRepository,
    this._addressRepository,
    this._notiCubit,
    this._cartRepository,
  ) : super(const CartStateV2());

  final appCubit = getIt.get<AppCubit>();
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();
  num? iWeight;
  num? iLength;
  num? iWidth;
  num? iHeight;
  num? iPrice;
  num? totalPrice;

  void changeOrderPayload(OrderPayloadModel? orderPayload) {
    emit(
      state.copyWith(
        orderPayload: orderPayload?.copyWith(
          customerInfo: state.addressSelected?.toJson(),
        ),
      ),
    );
  }

  void setAddressSelected(AddressModel addressSelected) {
    emit(
      state.copyWith(
        addressSelected: addressSelected,
        deliverySelected: DeliveryTypeModel(
          deliveryShipping: DeliveryShipping.pickUp,
          address: state.boothSelected?.fullAddress ?? "",
        ),
      ),
    );
    setReceiptAddress();

    changeOrderPayload(
      state.orderPayload?.copyWith(
        address: addressSelected.address['text'],
        customerInfo: addressSelected.toJson(),
      ),
    );
    // getListGrocery(getDeliveryMethod: true);
  }

  void setBoothSelected(BoothModel booth) {
    emit(
      state.copyWith(
        boothSelected: booth,
        deliverySelected: DeliveryTypeModel(
          deliveryShipping: DeliveryShipping.pickUp,
          address: booth.fullAddress ?? "",
        ),
      ),
    );
    setGroceryAddress();
    getDeliveryInfo();

    if (state.orderPayload != null) {
      changeOrderPayload(
        state.orderPayload!.copyWith(groceryId: booth.id),
      );
    }
  }

  void setBoothSelectedV2(BoothSelectModel booth) {
    try {
      emit(
        state.copyWith(
          boothSelected: booth.selected,
          booths: booth.booths ?? [],
          deliverySelected: DeliveryTypeModel(
            deliveryShipping: DeliveryShipping.pickUp,
            address: booth.selected?.fullAddress ?? "",
          ),
        ),
      );
      setGroceryAddress();
      getDeliveryInfo();
      // createGroceryQrCode();

      // getFirstPurchaseGift();

      if (state.orderPayload != null) {
        changeOrderPayload(
          state.orderPayload!.copyWith(groceryId: booth.selected?.id),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void deliverySelectHandle(DeliveryType value) {
    if (value == DeliveryType.pickUp) {
      priceDeliveryHandle(null);
    }
    // emit(state.copyWith(deliverySelected: value));
  }

  void priceDeliveryHandle(DeliveryPriceModel? value) {
    emit(state.copyWith(priceSelected: value));
  }

  String groceryWard = "";
  String groceryDistrict = "";
  String groceryProvince = "";
  String addressWard = "";
  String addressDistrict = "";
  String addressProvince = "";
  List<String> addressList = [];
  List<String> groceryAddress = [];

  void setReceiptAddress() {
    addressWard = "";
    addressDistrict = "";
    addressProvince = "";
    addressList.clear();
    addressList = (state.addressSelected?.address['text'] as String).split(",");
    if (addressList.isNotEmpty == true && (addressList.length) >= 4) {
      addressProvince = addressList.last;
      addressDistrict = addressList[addressList.length - 2];
      addressWard = addressList[addressList.length - 3];
    } else {
      // navigator.showErrorSnackBar(
      //   "Địa chỉ không hợp lệ .Vui lòng cập nhật lại địa chỉ 4 cấp cho địa chỉ nhận hàng",
      // );
      showOverlayToast(
        title:
            "Địa chỉ không hợp lệ .Vui lòng cập nhật lại địa chỉ 4 cấp cho địa chỉ nhận hàng",
        iconColor: AppColors.red_1,
      );
    }
  }

  void setGroceryAddress() {
    try {
      groceryWard = "";
      groceryDistrict = "";
      groceryProvince = "";
      groceryAddress.clear();
      if (state.boothSelected?.fullAddress != null) {
        groceryAddress = state.boothSelected!.fullAddress!.split(",");
        if (groceryAddress.isNotEmpty == true && (groceryAddress.length) >= 4) {
          groceryProvince = groceryAddress.last;
          groceryDistrict = groceryAddress[groceryAddress.length - 2];
          groceryWard = groceryAddress[groceryAddress.length - 3];
        }
      }
      if (groceryAddress.length >= 4 && addressList.length >= 4) {
        emit(state.copyWith(canOrder: true));
      } else {
        emit(state.copyWith(canOrder: false));

        showOverlayToast(
          title: "Địa chỉ của cửa hàng tạp hoá không hợp lệ .",
          iconColor: AppColors.red_1,
        );
      }
    } catch (e) {
      showOverlayToast(
        title: "Đã có lỗi xảy ra.",
        iconColor: AppColors.red_1,
      );
    }
  }

  void createOrder({
    required ProductModelV2 product,
    required List<OptionData> option,
  }) async {
    try {
      EasyLoading.show(dismissOnTap: false);
      final price = (product.quantity ?? 0) * (product.priceSell ?? 0);
      final options = option.map((e) => e.id).toList();

      emit(state.copyWith(status: CubitStatus.loading, canOrder: false));

      final orderPayload = {
        "order": {
          "title": "don test",
          "total": price,
          "company": product.companyData?.id,
        },
        "order_item": [
          {
            "quantity": product.quantity ?? 0,
            "price": product.priceSell ?? 0,
            "option": options,
          }
        ],
      };

      final res = await _orderRepository.orderCreate(orderPayload);
      EasyLoading.dismiss();

      res.fold(
        (l) {
          navigator.showAppTopSnackBar(
            l["message"] ?? 'Có lỗi xảy ra!',
            type: 'error',
          );
          emit(state.copyWith(status: CubitStatus.error, canOrder: true));
        },
        (r) {
          navigator.back();
          navigator.back();
          showOverlayToast(title: 'Đặt hàng thành công');
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      emit(state.copyWith(status: CubitStatus.error, canOrder: true));
    }
  }

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

  // void getListGrocery({
  //   String? keyword,
  //   bool? isEmpty,
  //   bool? getDeliveryMethod = false,
  // }) async {
  //   if (isEmpty == false && keyword!.isEmpty) {
  //     emit(state.copyWith(booths: []));
  //     return;
  //   }
  //   emit(state.copyWith(status: CubitStatus.loading));
  //   try {
  //     double latitude = getLat;
  //     double longitude = getLong;

  //     if (state.addressSelected != null) {
  //       final addressSelect = state.addressSelected;
  //       // .firstWhere((e) => e.isDefault == true, orElse: () => AddressModel());

  //       if (addressSelect!.address != null) {
  //         final locations =
  //             await getLatLngFromAddress(addressSelect.address['text']);
  //         if (locations.length > 1 && locations.every((e) => e != 0)) {
  //           latitude = locations.length > 1 ? locations[0] : getLat;
  //           longitude = locations.length > 1 ? locations[1] : getLong;
  //         }
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
  //         emit(state.copyWith(status: CubitStatus.loaded));
  //       },
  //       (r) {
  //         emit(state.copyWith(status: CubitStatus.success));
  //         final booths = (r["data"]["results"] as List<dynamic>)
  //             .map((e) => BoothModel.fromJson(e))
  //             .toList();
  //         if (booths.isNotEmpty) {
  //           emit(state.copyWith(booths: booths, boothSelected: booths.first));
  //         } else {
  //           emit(state.copyWith(booths: [], boothSelected: null));
  //         }

  //         if (getDeliveryMethod == true) {
  //           setGroceryAddress();
  //           getDeliveryInfo();
  //           createGroceryQrCode();
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       emit(state.copyWith(status: CubitStatus.loaded));
  //       navigator.showAppTopSnackBar(e.toString(), type: 'error');
  //       print(e.toString());
  //     }
  //   }
  //   emit(state.copyWith(status: CubitStatus.loaded));
  // }

  // Future<void> getListAddress({bool getDeliveryMethod = false}) async {
  //   try {
  //     emit(state.copyWith(status: CubitStatus.loading));
  //     final res = await _addressRepository.getListAddress();
  //     emit(state.copyWith(status: CubitStatus.loaded));

  //     res.fold((l) => {emit(state.copyWith(status: CubitStatus.loaded))}, (r) {
  //       final lstAddress = (r['data'] as List<dynamic>)
  //           .map((e) => AddressModel.fromJson(e))
  //           .toList();
  //       final defaultAddress =
  //           lstAddress.firstOrNullWhere((element) => element.isDefault == true);
  //       final addressFirst =
  //           (lstAddress.isNotEmpty == true) ? lstAddress.first : null;

  //       emit(
  //         state.copyWith(
  //           addressSelected: defaultAddress ?? addressFirst,
  //           address: lstAddress,
  //         ),
  //       );
  //       if (getDeliveryMethod) {
  //         setReceiptAddress();
  //       }
  //       getListGrocery(getDeliveryMethod: getDeliveryMethod);

  //       // appCubit.setAddressList(
  //       //   (r['data'] as List<dynamic>)
  //       //       .map(
  //       //         (e) => AddressModel.fromJson(e),
  //       //       )
  //       //       .toList(),
  //       // );
  //       // isSuccess = r['data'].length > 0;
  //       // EasyLoading.dismiss();
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     emit(state.copyWith(status: CubitStatus.loaded));
  //   }

  //   // EasyLoading.dismiss();
  // }

  void getCartProducts() async {
    emit(state.copyWith(status: CubitStatus.loading, isSelectAll: false));
    final res = await _cartRepository.getProducts();
    if (res.data?.isNotEmpty == true) {
      final isSelectAll = res.data!.every((element) => element.isSelect);
      final disableCheckAll = res.data!.any((element) => !element.isSelect);
      if (isSelectAll) {
        emit(state.copyWith(isSelectAll: isSelectAll));
      }
      if (disableCheckAll) {
        emit(state.copyWith(isSelectAll: false));
      }
    }

    emit(state.copyWith(status: CubitStatus.loaded, products: res.data ?? []));
  }

  void removeProduct(int? id) async {
    final res = await _cartRepository.deleteCartProduct([id ?? 0]);
    if (res.code == 200) {
      final products = state.products.map((e) => e).toList();
      products.removeWhere((element) => element.productUnitId == id);
      final isSelectAll = products.every((element) => element.isSelect);
      if (isSelectAll) {
        emit(state.copyWith(isSelectAll: isSelectAll));
      }
      if (products.isEmpty) {
        emit(state.copyWith(products: products, isSelectAll: false));
      }

      emit(state.copyWith(products: products));
    }
  }

  void changeCart(int id, num quantity) async {
    try {
      emit(state.copyWith(status: CubitStatus.loading));
      final res = await _cartRepository.updateCartProduct(id, quantity, true);
      if (res.code == 200) {
        final products = [...state.products];
        final newProduct = products.map((element) {
          if (element.productUnitId == id) {
            element = element.copyWith(quantity: quantity);
          }
          return element;
        }).toList();
        emit(state.copyWith(products: newProduct, status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  void selectCart(int? id) async {
    final products = [...state.products];
    final newProduct = products.map((element) {
      if (element.productUnitId == id) {
        element = element.copyWith(isSelect: !element.isSelect);
      }
      return element;
    }).toList();
    emit(state.copyWith(products: newProduct));
    final isCheckAll = newProduct.every((element) => element.isSelect);
    if (isCheckAll) {
      emit(state.copyWith(isSelectAll: true));
    }
    final disableCheckAll = newProduct.any((element) => !element.isSelect);
    if (disableCheckAll || newProduct.isEmpty) {
      emit(state.copyWith(isSelectAll: false));
    }
  }

  void onSelectAll(bool value) {
    final products = [...state.products];
    if (products.isNotEmpty) {
      final newProduct = products.map((element) {
        element = element.copyWith(isSelect: value);
        return element;
      }).toList();
      emit(state.copyWith(products: newProduct, isSelectAll: value));
    }
  }

  void setDelivery(DeliveryTypeModel res) {
    emit(state.copyWith(deliverySelected: res));
  }

  void setPaymentMothod(DropdownButtonModel payment) {
    emit(state.copyWith(paymentMethod: payment));
  }

  void disSelectAll() {
    final products = state.products.map((element) {
      element = element.copyWith(isSelect: false);
      return element;
    }).toList();
    emit(state.copyWith(products: products, isSelectAll: false));
  }

  void removeAllProduct() async {
    final ids = state.products.map((e) => e.productUnitId ?? 0).toList();
    final res = await _cartRepository.deleteCartProduct(ids);
    if (res.code == 200) {
      final products = state.products.map((e) => e).toList();
      products.clear();
      emit(state.copyWith(products: [], isSelectAll: false));
    }
  }

  void getDeliveryInfo() {
    setPickUpStore();
    emit(
      state.copyWith(
        lstviettelPost: [],
        ghtk: null,
      ),
    );

    if (addressList.length >= 4 && groceryAddress.length >= 4) {
      getListViettelPost();
      // if ((iWeight ?? 0) < 20) {
      //   getGHTK();
      // } tạm bỏ phần GHTK
    }
  }

  void setPickUpStore() {
    emit(
      state.copyWith(
        deliverySelected: DeliveryTypeModel(
          deliveryShipping: DeliveryShipping.pickUp,
          address: state.addressSelected!.address['text'] ?? '',
        ),
      ),
    );
  }

  Future<void> getListViettelPost() async {
    try {
      final res = await _cartRepository.getListViettelPost(
        shopAddress: state.boothSelected?.fullAddress ?? "",
        userAddress: state.addressSelected?.address['text'] ?? '',
        weight: iWeight,
        height: iHeight,
        length: iLength,
        width: iWidth,
        price: iPrice,
      );
      emit(
        state.copyWith(
          isLoading: false,
          lstviettelPost: res.data ?? [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      EasyLoading.dismiss();
    }
  }

  Future<void> getGHTK() async {
    final res = await _cartRepository.getGHTK(
      senderAddress: state.boothSelected?.fullAddress ?? "",
      receiverAddress: state.addressSelected?.address['text'] ?? '',
      weight: iWeight,
      height: iHeight,
      length: iLength,
      width: iWidth,
      price: iPrice,
    );
    emit(state.copyWith(ghtk: res.data));
  }

  void onSelectDelivery(DeliveryTypeModel delivery) {
    emit(state.copyWith(deliverySelected: delivery));
  }

  void calculatorDeliveryInfo() {
    final data = orderBuy.where((e) => e.isSelect).toList();
    final totalPrice = data.fold(
      0.0,
      (sum, e) => sum + ((e.retailPrice ?? 0) * (e.quantity ?? 0)),
    );
    final quantity = data.fold(
      0.0,
      (sum, element) => sum + (element.quantity ?? 0),
    );
    final weight = data.fold(
      0.0,
      (sum, e) => sum + ((e.quantity ?? 0) * (e.massOut ?? 0)),
    );
    iWeight = weight;
    iLength = quantity * 30;
    iWidth = quantity * 30;
    iHeight = quantity * 30;
    iPrice = totalPrice;
    // setPickUpStore();
    getDeliveryInfo();
  }

  num allPrice = 0;
  List<CartModelV2> orderBuy = [];
  void initDataOrderBuy(num price, String time, List<CartModelV2> orderItems) {
    allPrice = price;
    timestamp = time;
    orderBuy = orderItems;
  }

  void updateDeviceToken() async {
    try {
      if (appCubit.state.isLoggedIn) {
        final notificationSettings = FirebaseMessaging.instance;
        final deviceToken = await notificationSettings.getToken();
        if (deviceToken != null) {
          final id = preferences.currentUser.user?.id ?? 0;
          final res = await _cartRepository.updateDeviceToken(deviceToken, id);
          if (res.code == 200) {
            showOverlayToast(
              title: "BGP_Retail đã xác thực được mã thiết bị",
            );
          }
          // else {
          //   showOverlayToast(
          //     title: "BGP_Retail không xác định đc mã thiết bị",
          //     iconColor: AppColors.red_1,
          //   );
          // }
        }
      }
    } catch (e) {
      // showOverlayToast(
      //   title: "BGP_Retail không xác định đc mã thiết bị",
      //   iconColor: AppColors.red_1,
      // );
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void clearCartCubit() {
    emit(
      state.copyWith(
        addressSelected: null,
        boothSelected: null,
        address: [],
        booths: [],
      ),
    );
  }

  // Future<List<BoothModel>> getShopList({String? keyword}) async {
  //   double latitude = getLat;
  //   double longitude = getLong;
  //   if (state.addressSelected != null) {
  //     final addressSelect = state.addressSelected;

  //     if (addressSelect!.address != null) {
  //       final locations =
  //           await getLatLngFromAddress(addressSelect.address['text']);
  //       if (locations.length > 1 && locations.every((e) => e != 0)) {
  //         latitude = locations.length > 1 ? locations[0] : getLat;
  //         longitude = locations.length > 1 ? locations[1] : getLong;
  //       }
  //     }
  //   }

  //   final res = await _boothRepository.getShopList(
  //     keyword: keyword,
  //     page: 0,
  //     pageSize: 5,
  //     latitude: latitude,
  //     longitude: longitude,
  //   );
  //   if (res.code == 200) {
  //     return res.data ?? [];
  //   } else {
  //     return [];
  //   }
  // }

  void getFirstPurchaseGift() async {
    if (state.gift != null) {
      emit(state.copyWith(gift: null));
    }
    final accountId = preferences.currentUser.user?.id ?? 0;
    final res = await _boothRepository.getFirstPurchaseGift(
      accountId: accountId,
    );
    if (res.code == 200) {
      emit(state.copyWith(gift: res.data));
    }
  }

  void deleteGift() {
    emit(state.copyWith(gift: null));
  }

  String? timestamp;

  // void createGroceryQrCode() async {
  //   try {
  //     emit(state.copyWith(status: CubitStatus.loading));
  //     final id = state.boothSelected?.id ?? 0;
  //     final lstBank = await _cartRepository.getBankAccountInfo(id);
  //     if (lstBank.data?.isNotEmpty == true) {
  //       final bank = lstBank.data?.first;
  //       emit(state.copyWith(accountBank: bank));
  //       final res = await _cartRepository.getQrCode(
  //         bank?.bin,
  //         bank?.bankAccount ?? "",
  //         allPrice,
  //         "${removeVietnameseTones(state.addressSelected?.fullname ?? "").toUpperCase()} ${preferences.currentUser.user?.id}.${state.boothSelected?.id}.$timestamp",
  //       );
  //       emit(state.copyWith(status: CubitStatus.success));
  //       if (res.code == 200) {
  //         emit(state.copyWith(imageQr: res.data));
  //       } else {
  //         emit(state.copyWith(imageQr: null));
  //         showOverlayToast(
  //           title: "Chưa tải được mã QR Code vui lòng tải lại",
  //           iconColor: AppColors.red_1,
  //         );
  //       }
  //     } else {
  //       EasyLoading.dismiss();
  //       emit(state.copyWith(imageQr: null, status: CubitStatus.loaded));
  //       showOverlayToast(
  //         title: "Chưa tải được mã QR Code vui lòng tải lại",
  //         iconColor: AppColors.red_1,
  //       );
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     emit(state.copyWith(status: CubitStatus.loaded, imageQr: null));
  //     showOverlayToast(
  //       title: "Chưa tải được mã QR Code vui lòng tải lại",
  //       iconColor: AppColors.red_1,
  //     );
  //   }
  // }
}
