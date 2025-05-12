import 'package:dartx/dartx.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/core/utilities/funtion.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/card/data/models/bank_model.dart';
import 'package:BGP_Retail/features/card/data/models/bank_model.dart';
import 'package:BGP_Retail/features/cart/data/bloc/cart_bloc_V2.dart';
import 'package:BGP_Retail/features/cart/data/models/ghtk_model.dart';
import 'package:BGP_Retail/features/cart/data/repositories/cart_repository.dart';
import 'package:BGP_Retail/features/home/data/model/product_model_v2.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';
import 'package:BGP_Retail/features/profile/data/models/deposit_qr_code_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/address_repository.dart';
import 'package:BGP_Retail/features/profile/data/repositories/payment_repository.dart';

import 'package:BGP_Retail/features/wallet/data/models/card_wallet_model.dart';

@Injectable()
class AsbcCartBuyCubit extends Cubit<CubitState> {
  AsbcCartBuyCubit(
    this._addressRepository,
    this._cartRepository,
    this._paymentRepository,
  ) : super(CubitState());

  final AddressRepository _addressRepository;
  final CartRepository _cartRepository;
  final PaymentRepository _paymentRepository;
  List<ProductModelV2>? products;
  ProductModelV2? product; // GIỮ CHO BẢN CŨ
  List<OptionData>? option;
  num get totalPrice => products!.fold(
        0,
        (pre, element) {
          final optionSelectIds =
              element.optionSelect?.map((e) => e.id ?? 0).toList();
          final variantSelect = element.variant?.firstOrNullWhere(
            (element) {
              final variantIds =
                  element.options?.map((e) => e.id ?? 0).toList();
              return areListsEqual(variantIds, optionSelectIds);
            },
          );
          return pre +
              (element.quantity ?? 0) * (variantSelect?.priceSell ?? 0);
        },
      );
  //
  num weight = 1;
  num height = 1;
  num length = 1;
  num width = 1;

  List<AsbcAddressModel>? listAddress = [];
  AsbcAddressModel? addressSelected;
  AsbcAddressModel? addressSelect;
  // PaymentMethodEnum methodPick = PaymentMethodEnum.banking;
  PaymentMethodEnum? methodSelected;
  DeliveryMethodEnum? deliveryTypePick;
  DeliveryMethodEnum? deliveryTypeSelected;
  CardWalletModel? walletSelected;
  // CardWalletModel? walletPick;
  List<ViettelPostModel> viettelPostDelivery = [];
  ViettelPostModel? deliveryPick;
  ViettelPostModel? deliveryMethodSelected;
  String? shopAddress;
  DepositQrCodeModel? orderQrCode;
  final navigator = getIt.get<AppNavigator>();
  final cartBloc = getIt.get<CartV2Bloc>();
  final id = getIt.get<Preferences>().currentUser.user?.id;

  BankModel? asbcBank;

  Future<void> getASBCListAddress() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _addressRepository.getASBCListAddress();
    try {
      if (res.code == 200) {
        listAddress = res.data;
        if (listAddress?.isNotEmpty == true) {
          final isDefault =
              listAddress?.firstOrNullWhere((e) => e.isDefault == true);
          addressSelected = isDefault ?? listAddress?.first;
          addressSelect = isDefault ?? listAddress?.first;
        }

        emit(state.copyWith(status: CubitStatus.loaded));
        getListViettelPost();
      } else {
        emit(state.copyWith(status: CubitStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  Future<void> getListViettelPost() async {
    try {
      final res = await _cartRepository.getListViettelPost(
        shopAddress: shopAddress ?? "",
        userAddress: addressSelected?.addressFull ?? '',
        weight: weight,
        height: height,
        length: length,
        width: width,
        price: totalPrice,
      );
      viettelPostDelivery = res.data ?? [];
      emit(state.copyWith(status: CubitStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  void updateSelectAddress(AsbcAddressModel? address) {
    addressSelected = address;
    getListViettelPost();

    // emit(state.copyWith(status: CubitStatus.loaded));
  }

  void selectAddress(AsbcAddressModel? address) {
    addressSelect = address;
    // addressSelect = address;
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  // void pickPaymentMethod(PaymentMethodEnum value, {CardWalletModel? wallet}) {
  //   walletPick = wallet;
  //   methodPick = value;
  //   emit(state.copyWith(status: CubitStatus.loaded));
  // }

  void updatePaymentMethod(
    PaymentMethodEnum? payment,
    CardWalletModel? wallet,
  ) {
    methodSelected = payment!;
    walletSelected = wallet;
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void setShopAddress(String? address) {
    shopAddress = address;
  }

  void pickDeliveryMethod(
    DeliveryMethodEnum ship, {
    ViettelPostModel? delivery,
  }) {
    deliveryTypePick = ship;
    deliveryPick = delivery;
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void updateDeliveryMethod(int totalPrice) {
    deliveryMethodSelected = deliveryPick;
    deliveryTypeSelected = deliveryTypePick;
    // createQrOrder(totalPrice);
    emit(state.copyWith(status: CubitStatus.loaded));
  }

  // void createQrOrder(int totalPrice) async {
  //   emit(state.copyWith(status: CubitStatus.loading));
  //   final res = await _paymentRepository.createDeposit(totalPrice);
  //   if (res.code == 200) {
  //     orderQrCode = res.data;
  //     emit(state.copyWith(status: CubitStatus.sendSuccess));
  //   } else {
  //     emit(state.copyWith(status: CubitStatus.loaded));
  //   }
  // }

  void createOrder() async {
    try {
      final isPickUp = deliveryTypeSelected == DeliveryMethodEnum.pickUp;
      EasyLoading.show(dismissOnTap: false);
      emit(state.copyWith(status: CubitStatus.loading));

      final orderPayload = {
        "order": {
          "order_type": 1, //phân biệt đơn Online/Off
          "title": "don test",
          "total": totalPrice,
          "company": products?.firstOrNull?.companyData?.id,
          "customer": id,
          "receiver_address": addressSelected?.addressData?.id,
        },
        "order_item": products!.map(
          (prd) {
            // final variant = prd.variant?.firstOrNull;

            final optionSelectIds =
                prd.optionSelect?.map((e) => e.id ?? 0).toList();
            final variantSelect = prd.variant?.firstOrNullWhere(
              (element) {
                final variantIds =
                    element.options?.map((e) => e.id ?? 0).toList();
                return areListsEqual(variantIds, optionSelectIds);
              },
            );

            return {
              "quantity": prd.quantity ?? 0,
              "price": variantSelect?.priceSell ?? 0,
              "option": prd.optionSelect?.map((e) => e.id).toList(),
            };
          },
        ).toList(),
      };
      final orderPayloadPrice =
          totalPrice + (isPickUp ? 0 : (deliveryMethodSelected?.giaCuoc ?? 0));
      if (methodSelected == PaymentMethodEnum.banking) {
        orderPayload['payment_method'] = {
          "title": 'BANKING',
          "total": orderPayloadPrice,
        };
      } else {
        orderPayload['payment_method'] = {
          "title": 'WALLET',
          "total": orderPayloadPrice,
          "wallet_type": walletSelected?.type,
        };
      }
      if (!isPickUp) {
        orderPayload["order_dlo"] = {
          "order_service": deliveryMethodSelected?.maDvChinh,
          "title_service":
              isPickUp ? "Lấy tại cửa hàng" : deliveryMethodSelected?.tenDichvu,
          "time_receiver": deliveryMethodSelected?.thoiGian,
          "transport_fee": deliveryMethodSelected?.giaCuoc,
        };
      }
      if (isCart == true) {
        orderPayload["cart_item"] = products!.map((e) => e.id).toList();
      }

      final res = await _cartRepository.createOnlineOrder(orderPayload);
      EasyLoading.dismiss();
      if (res.code == 200) {
        emit(state.copyWith(status: CubitStatus.sendSuccess));
        navigator.back();
        navigator.push(OrderDetailPage(code: res.data));
        showOverlayToast(title: 'Đặt hàng thành công');
        if (isCart == true) {
          cartBloc.getCart();
        }
      } else {
        emit(state.copyWith(status: CubitStatus.sendFaild));
        showOverlayToast(title: res.message ?? 'Có lỗi xảy ra!');
      }
    } catch (e) {
      EasyLoading.dismiss();
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  void createOrderV2() async {
    try {
      final isPickUp = deliveryTypeSelected == DeliveryMethodEnum.pickUp;
      EasyLoading.show(dismissOnTap: false);
      final id = getIt.get<Preferences>().currentUser.user?.id;
      emit(state.copyWith(status: CubitStatus.loading));

      final orderPayload = {
        "order": {
          "order_type": 1, //phân biệt đơn Online/Off
          "title": "don test",
          "total": totalPrice,
          "company": products?.firstOrNull?.companyData?.id,
          "customer": id,
          "receiver_address": addressSelected?.accountData?.id,
        },
        "order_item": [
          products!.map(
            (e) => {
              "quantity": e.quantity ?? 0,
              "price": e.priceSell ?? 0,
              "option":
                  e.variant?.firstOrNull?.option?.map((e) => e.id).toList(),
            },
          ),
        ],
      };
      if (methodSelected == PaymentMethodEnum.banking) {
        orderPayload['payment_method'] = {
          "title": 'BANKING',
          "total": totalPrice +
              (isPickUp ? 0 : (deliveryMethodSelected?.giaCuoc ?? 0)),
        };
      } else {
        orderPayload['payment_method'] = {
          "title": 'WALLET',
          "total": totalPrice,
          "wallet_type": walletSelected?.type,
        };
      }
      if (!isPickUp) {
        orderPayload["order_dlo"] = {
          "order_service": deliveryMethodSelected?.maDvChinh,
          "title_service":
              isPickUp ? "Lấy tại cửa hàng" : deliveryMethodSelected?.tenDichvu,
          "time_receiver": deliveryMethodSelected?.thoiGian,
          "transport_fee": deliveryMethodSelected?.giaCuoc,
        };
      }

      final res = await _cartRepository.createOnlineOrder(orderPayload);
      EasyLoading.dismiss();
      if (res.code == 200) {
        emit(state.copyWith(status: CubitStatus.sendSuccess));
        navigator.back();
        navigator.push(OrderDetailPage(code: res.data));
        showOverlayToast(title: 'Đặt hàng thành công');
      } else {
        emit(state.copyWith(status: CubitStatus.sendFaild));
        showOverlayToast(title: res.message ?? 'Có lỗi xảy ra!');
      }
    } catch (e) {
      EasyLoading.dismiss();
      emit(state.copyWith(status: CubitStatus.error));
    }
  }

  void initProduct(ProductModelV2? prod, List<OptionData>? opt) {
    product = prod;
    option = opt;
  }

  bool? isCart = false;
  void initProductV2(List<ProductModelV2>? prods, bool? cart) {
    if (prods?.isNotEmpty == true) {
      weight = 0;
      height = 0;
      length = 0;
      width = 0;
      for (final prd in prods!) {
        // final product = products[index];

        // final variant = product.variant?.firstOrNull;

        final optionSelectIds =
            prd.optionSelect?.map((e) => e.id ?? 0).toList();
        final variantSelect = prd.variant?.firstOrNullWhere(
          (element) {
            final variantIds = element.options?.map((e) => e.id ?? 0).toList();
            return areListsEqual(variantIds, optionSelectIds);
          },
        );
        // final productPrice =
        //     (product.quantity ?? 0) * (variantSelect?.priceSell ?? 0);

        final quantity = prd.quantity.validator;
        weight = weight + (variantSelect?.weight).validator * quantity;
        height = (height + (variantSelect?.height).validator);
        length = (length + (variantSelect?.length).validator * quantity);
        width = (height + (variantSelect?.width).validator);
      }
    }

    products = prods;
    isCart = cart;
  }

  void getBankASBC() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _paymentRepository.getBankASBC();
    if (res.code == 200) {
      asbcBank = res.data;
      emit(state.copyWith(status: CubitStatus.success));
    } else {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }
}
