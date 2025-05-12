import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/utilities/debouncer.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/buttons/filter_button.dart';
import 'package:BGP_Retail/features/profile/data/bloc/payment_history_state.dart';
import 'package:BGP_Retail/features/profile/data/models/payment_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/payment_repository.dart';

@Injectable()
class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  PaymentHistoryCubit(this._repo) : super(const PaymentHistoryState());

  final PaymentRepository _repo;

  final transactionType = [
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Thanh toán đơn", value: 1),
    const FilterButtonModel(title: "Hoàn tiền hủy đơn", value: 2),
    const FilterButtonModel(title: "Rút tiền", value: 3),
    const FilterButtonModel(title: "Nạp tiền", value: 4),
    const FilterButtonModel(title: "Nhận chuyển tiền", value: 5),
    const FilterButtonModel(title: "Chuyển tiền", value: 6),
  ];
  final walletType = [
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Ví rút tiền", value: 0),
    const FilterButtonModel(title: "Ví mua hàng", value: 1),
    const FilterButtonModel(title: "Ví quà tặng", value: 2),
    const FilterButtonModel(title: "Ví cashback", value: 3),
    const FilterButtonModel(title: "Ví đối soát", value: 4),
  ];

  int page = 1;
  int? wallet;
  int? type;
  String? search;
  String? from;
  String? to;
  int total = 0;
  bool isMore = true;
  final _debouncer = Debouncer();
  List<PaymentModel> list = [];

  void getPaymentHistory() async {
    if (page == 1) {
      emit(state.copyWith(isLoading: true));
      list.clear();
    }
    if (isMore) {
      emit(state.copyWith(stauts: CubitStatus.loadMore));
    }
    final res =
        await _repo.getPaymentHistory(page, wallet, type, search, from, to);

    if (res.code == 200) {
      list.addAll(res.data ?? []);
      isMore = res.data?.length == 10;
    }
    emit(state.copyWith(isLoading: false, stauts: CubitStatus.loaded));
  }

  void getPaymentDetail(String code) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.getPaymentDetail(code);

    if (res.code == 200) {
      emit(state.copyWith(detail: res.data));
    }
    emit(state.copyWith(isLoading: false));
  }

  void selectTransaction(value) {
    emit(state.copyWith(indexTransaction: value));
  }

  void onFilterTransaction(value) {
    emit(state.copyWith(indexTransaction: value));
    type = value;
    onRefresh();
  }

  void selectWallet(value) {
    emit(state.copyWith(indexWallet: value));
  }

  void setFilter(FilterArgModel result) {
    total = 0;

    wallet = result.wallet;
    if (result.wallet != null) {
      total++;
    }
    emit(state.copyWith(indexWallet: result.wallet));
    type = result.transaction;

    if (result.transaction != null) {
      total++;
    }
    emit(state.copyWith(indexTransaction: result.transaction));

    if (!result.start.nullOrEmpty) {
      from = result.start;
      total++;
    }
    if (!result.end.nullOrEmpty) {
      to = result.end;
      total++;
    }
    page = 1;
    getPaymentHistory();
  }

  void initData(int? type, int? wallet) {
    emit(state.copyWith(indexWallet: wallet, indexTransaction: type));
  }

  void onLoadMore() {
    page++;
    getPaymentHistory();
  }

  void onRefresh() {
    page = 1;
    list.clear();
    getPaymentHistory();
  }

  void onSearch(String value) {
    search = value;
    _debouncer.run(
      () => onRefresh(),
    );
  }
}
