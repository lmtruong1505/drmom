import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/configs/enums/noti_enum.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/features/card/data/models/bank_model.dart';
import 'package:BGP_Retail/features/order/data/bloc/order_detail_state.dart';
import 'package:BGP_Retail/features/order/data/models/order_asbc_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_model.dart';
import 'package:BGP_Retail/features/order/data/repositories/order_repository.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';
import 'package:BGP_Retail/features/profile/data/models/deposit_qr_code_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/payment_repository.dart';
import 'package:BGP_Retail/features/wallet/data/models/card_wallet_model.dart';
import 'package:overlay_support/overlay_support.dart';

@injectable
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(
    this._orderRepository,
    this._notiCubit,
    this._paymentRepository,
  ) : super(const OrderDetailState());
  final OrderRepository _orderRepository;
  final NotificationCubit _notiCubit;
  final PaymentRepository _paymentRepository;

  DepositQrCodeModel? orderQrCode;
  BankModel? asbcBank;
  PaymentMethodEnum? paymentMothod;
  num? walletSelectId;
  final navigator = getIt.get<AppNavigator>();

  final preferences = getIt.get<Preferences>();
  void orderDetail(String code) async {
    emit(state.copyWith(isLoading: true, status: CubitStatus.loading));
    try {
      final res = await _orderRepository.orderDetailV2(code);
      if (res.code == 200) {
        emit(
          state.copyWith(
            order: res.data,
            isLoading: false,
            status: CubitStatus.success,
          ),
        );
        if (state.order?.statusData?.code == 'CTT') {
          final order = state.order;
          final totalPrice =
              (order?.total ?? 0) + (order?.orderDlo?.transportFee ?? 0);
          createQrOrder(totalPrice, state.order?.id);
        }

        paymentMothod = state.order?.paymentMethod?.title == 'BANKING'
            ? PaymentMethodEnum.banking
            : PaymentMethodEnum.wallet;

        if (paymentMothod == PaymentMethodEnum.wallet) {
          walletSelectId = state.order?.paymentMethod?.walletData?.type;
        }
      } else {
        emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, status: CubitStatus.error));
    }
  }

  void getReasonCancel(OrderEnum type) async {
    try {
      final res = await _orderRepository.getReasonCancel(type.code ?? '');
      if (res.code == 200) {
        if (type == OrderEnum.CANCEL) {
          emit(state.copyWith(reason: res.data));
        } else {
          emit(state.copyWith(listComplant: res.data));
        }
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // void orderConfirm({
  //   required int id,
  //   required String status,
  //   String? reason,
  //   OrderModel? order,
  // }) async {
  //   emit(state.copyWith(isLoading: true));
  //   showLoading();
  //   try {
  //     final res = await _orderRepository.orderConfirm(
  //       id: id,
  //       status: status,
  //       reason: reason,
  //     );
  //     EasyLoading.dismiss();
  //     emit(state.copyWith(isLoading: false));
  //     res.fold(
  //       (l) {},
  //       (r) {
  //         // callback.call();
  //         final user = preferences.currentUser.user;

  //         final userName = user?.fullname;
  //         final userId = user?.id;
  //         final order = state.order;
  //         // final orderCode = order?.orderCode;

  //         // final contentObj = {
  //         //   "DONE": "Khách hàng $userName đã nhận đơn hàng $orderCode",
  //         //   "RETURN": "Khách hàng $userName yêu cầu hoàn đơn hàng $orderCode",
  //         //   "CANCEL": "Khách hàng $userName đã hủy đơn hàng $orderCode",
  //         // };

  //         final titleObj = {
  //           "DONE": "Đơn hàng từ TMĐT chuyển trạng thái đã nhận hàng",
  //           "RETURN": "Đơn hàng từ TMĐT chuyển trạng thái hoàn hàng",
  //           "CANCEL": "Đơn hàng từ TMĐT chuyển trạng thái đã hủy đơn",
  //         };

  //         // final Map<String, dynamic> dataNotify = {
  //         //   "module": ModuleEnum.TM_ORDER.title,
  //         //   "custom_id": id,
  //         //   "status": false,
  //         //   "title": titleObj[status],
  //         //   "content": contentObj[status],
  //         //   "data": '',
  //         //   "user_created": userId,
  //         //   "user_updated": userId,
  //         //   "is_failed": status == 'CANCEL' ? true : false,
  //         // };

  //         // _notiCubit.createNoti(
  //         //   dataNotify: dataNotify,
  //         //   listUser: [order?.grocery?.id ?? 0],
  //         // );
  //         final now = DateTime.now().toString();
  //         if (status == 'DONE') {
  //           // final newOrder = state.order?.copyWith(orderStatus: "DONE");
  //           // emit(state.copyWith(order: newOrder, hasUpdate: true));
  //         } else if (status == 'RETURN') {
  //           // final newOrder = state.order?.copyWith(
  //           //   orderStatus: "RETURN",
  //           //   reason: reason,
  //           //   reasonDate: now,
  //           // );
  //           // emit(state.copyWith(order: newOrder, hasUpdate: true));
  //         } else if (status == 'CANCEL') {
  //           // final newOrder = state.order?.copyWith(
  //           //   orderStatus: "CANCEL",
  //           //   reason: reason,
  //           //   reasonDate: now,
  //           // );
  //           // emit(state.copyWith(order: newOrder, hasUpdate: true));
  //         }

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
  //                             Icons.check_circle_rounded,
  //                             color: AppColors.green_1,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     title: const Text('Thông báo'),
  //                     subtitle: const Text('Thao tác thành công'),
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       vertical: 6,
  //                       horizontal: 16,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           duration: const Duration(milliseconds: 2000),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //     EasyLoading.dismiss();
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }

  void orderCancel({
    required OrderEnum? orderType,
    DataModel? reason,
    required int id,
  }) async {
    showLoading();
    try {
      emit(state.copyWith(status: CubitStatus.loading));
      final res = await _orderRepository.orderCancel(
        orderType: orderType,
        id: id,
        reason: reason,
      );

      // emit(state.copyWith(isLoading: false));
      res.fold(
        (l) {
          EasyLoading.dismiss();
          // emit(state.copyWith(status: CubitStatus.sendFaild));
        },
        (r) {
          emit(state.copyWith(status: CubitStatus.update, hasUpdate: true));
          EasyLoading.dismiss();
          // final newOrder = state.order
          //     ?.copyWith(statusOrderData: DataModel(title: reason, id: 6));
          // emit(state.copyWith(order: newOrder, hasUpdate: true));

          showOverlayNotification(
            (context) {
              return SafeArea(
                child: GestureDetector(
                  onTap: () {
                    OverlaySupportEntry.of(context)?.dismiss();
                  },
                  child: Card(
                    child: ListTile(
                      leading: SizedBox.fromSize(
                        size: const Size(40, 40),
                        child: ClipOval(
                          child: Container(
                            color: AppColors.green_2,
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.green_1,
                            ),
                          ),
                        ),
                      ),
                      title: const Text('Thông báo'),
                      subtitle: const Text('Thao tác thành công'),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
            duration: const Duration(milliseconds: 2000),
          );
        },
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: CubitStatus.loaded));
      // EasyLoading.dismiss();
      // emit(state.copyWith(isLoading: false));
    }
  }

  void createQrOrder(
    num totalPrice,
    num? orderId,
  ) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res =
        await _paymentRepository.createDeposit(totalPrice, orderId: orderId);
    if (res.code == 200) {
      orderQrCode = res.data;
      emit(state.copyWith(status: CubitStatus.success));
    } else {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  void setPaymentMethod(PaymentMethodEnum? value, num? type) {
    emit(state.copyWith(status: CubitStatus.loading));
    paymentMothod = value;
    walletSelectId = type;
    emit(state.copyWith(status: CubitStatus.update));
  }

  void confirmPayment() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final order = state.order;
    final id = order?.id;
    final Map<String, dynamic> payload = {"id": id};
    final paymentNow =
        paymentMothod == PaymentMethodEnum.wallet ? "WALLET" : "BANKING";
    final isChangeMethod = order?.paymentMethod?.title != paymentNow;
    final isChanngeWallet =
        order?.paymentMethod?.walletData?.type != walletSelectId;
    if (isChangeMethod) {
      if (paymentMothod == PaymentMethodEnum.banking) {
        payload['payment_method'] = {"title": "BANKING"};
      } else {
        payload['payment_method'] = {
          "title": "WALLET",
          "wallet": walletSelectId,
        };
      }
    } else if (isChanngeWallet) {
      payload['payment_method'] = {
        "title": "WALLET",
        "wallet": walletSelectId,
      };
    }
    // print(payload);
    final res = await _orderRepository.confirmPayment(payload);
    if (res.code == 200) {
      navigator.pop();
      navigator.pop();
      navigator.pop();
      emit(state.copyWith(status: CubitStatus.sendSuccess, hasUpdate: true));
    } else {
      navigator.pop();
      navigator.pop();
      navigator.pop();
      emit(state.copyWith(status: CubitStatus.sendFaild));
    }
  }

  void getBankASBC() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _paymentRepository.getBankASBC();
    if (res.code == 200) {
      asbcBank = res.data;
      emit(state.copyWith(status: CubitStatus.loaded));
    } else {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  void updateStatusOrder(int statusId, int id) async {
    final res = await _orderRepository.updateStatusOrder(statusId, id);
    if (res.code == 200) {
      emit(state.copyWith(status: CubitStatus.update, hasUpdate: true));
    } else {
      emit(state.copyWith(status: CubitStatus.sendFaild));
    }
  }
}
