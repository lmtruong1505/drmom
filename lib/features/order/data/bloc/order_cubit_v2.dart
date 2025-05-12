import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/preferences/preferences.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/utilities/debouncer.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/features/order/data/models/order_asbc_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_model.dart';
import 'package:BGP_Retail/features/order/data/repositories/order_repository.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_bloc.dart';

import 'order_state_v2.dart';

@injectable
class OrderCubitV2 extends Cubit<OrderStateV2> {
  OrderCubitV2(
    this._orderRepository,
    this._notiCubit,
  ) : super(const OrderStateV2());

  final OrderRepository _orderRepository;
  final NotificationCubit _notiCubit;

  int _pageNumber = 1;
  bool isMore = true;
  String keywordSearch = "";
  final _debouncer = Debouncer();

  final Preferences preferences = getIt.get<Preferences>();
  final AppNavigator navigator = getIt.get<AppNavigator>();

  // void setOrder(OrderModel order) {
  //   emit(state.copyWith(order: order));
  // }

  void onShowBG(bool isBool) {
    emit(state.copyWith(isShowBg: isBool));
  }

  void getOrders() async {
    try {
      if (_pageNumber == 1) {
        emit(state.copyWith(isLoading: true, orders: []));
      } else {
        emit(state.copyWith(status: CubitStatus.loadMore));
      }
      print("====showlOaddddd===$_pageNumber===$isMore");
      final res = await _orderRepository.getOrdersV2(
        search: keywordSearch,
        page: _pageNumber,
        status: state.filter.value,
      );
      if (res.code == 200) {
        final updateOrders = List<OrderAsbcModel>.from(state.orders ?? [])
          ..addAll(res.data ?? []);
        emit(
          state.copyWith(
            orders: updateOrders,
            isLoading: false,
            status: CubitStatus.loaded,
          ),
        );

        if ((res.data?.length ?? 0) < 10) {
          isMore = false;
        }
      } else {
        isMore = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(
        state.copyWith(
          isLoading: false,
          status: CubitStatus.loaded,
        ),
      );
    }
  }

  void getTotalOrders() async {
    try {
      final res = await _orderRepository.getCountOrders();
      if (res.code == 200) {
        emit(
          state.copyWith(
            count: res.data,
            isLoading: false,
            status: CubitStatus.loaded,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(
        state.copyWith(
          isLoading: false,
          status: CubitStatus.loaded,
        ),
      );
    }
  }

  void onLoadMore() {
    if (isMore) {
      _pageNumber++;
      getOrders();
    }
  }

  void onFilter(FilterButtonModel value) {
    _pageNumber = 1;
    isMore = true;
    emit(state.copyWith(orders: [], filter: value));
    getOrders();
  }

  void onSearch(String value) {
    _debouncer.run(() {
      _pageNumber = 1;
      isMore = true;
      keywordSearch = value;
      emit(state.copyWith(orders: []));
      getOrders();
    });
  }

  void onRefresh() {
    _pageNumber = 1;
    isMore = true;
    emit(state.copyWith(orders: []));
    getOrders();
    getTotalOrders();
  }
}
