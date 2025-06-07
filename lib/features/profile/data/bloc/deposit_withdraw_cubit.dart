import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:bpg_retail/features/profile/data/models/bank_model.dart';
import 'package:bpg_retail/features/profile/data/repositories/payment_repository.dart';

@Injectable()
class DepositWithdrawCubit extends Cubit<DepositWithdrawState> {
  DepositWithdrawCubit(this._repo) : super(const DepositWithdrawState());

  int page = 1;
  bool isEdit = false;
  // bool isEditBank = false;
  String? key;
  final debounce = Debouncer();
  MyBankModel? bankDetail;

  final listFilter = [
    const FilterButtonModel(title: "Tất cả", value: null),
    const FilterButtonModel(title: "Chờ duyệt ", value: 1),
    const FilterButtonModel(title: "Đang xử lý", value: 2),
    const FilterButtonModel(title: "Hoàn thành", value: 3),
  ];

  final PaymentRepository _repo;
  void onChangeTab(int i) {
    emit(state.copyWith(index: i));
  }

  void setEdit(bool edit) {
    isEdit = true;
    emit(state.copyWith(status: CubitStatus.update));
  }

  void createDeposit(int money) async {
    emit(state.copyWith(isLoading: true, status: CubitStatus.loading));
    final res = await _repo.createDeposit(money);
    if (res.code == 200) {
      emit(state.copyWith(deposit: res.data, status: CubitStatus.sendSuccess));
    } else {
      emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
    }
  }

  void getHistoryDeposit() async {
    if (page == 1) {
      emit(state.copyWith(isLoading: true, status: CubitStatus.loading));
    } else {
      emit(state.copyWith(status: CubitStatus.loading));
    }
    final res = await _repo.getHistoryDeposit(page, state.index, key);
    if (res.code == 200) {
      emit(
        state.copyWith(
          isLoading: false,
          listHistory: res.data,
          status: CubitStatus.sendSuccess,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
    }
  }

  void onSearch(String keySearch) {
    key = keySearch;

    debounce.run(() {
      onRefresh();
      getHistoryDeposit();
    });
  }

  void onLoadMore() {
    page++;
    getHistoryDeposit();
  }

  void onRefresh() {
    page = 1;
    getHistoryDeposit();
  }

  void onFilter(value) {
    emit(state.copyWith(index: value));
    onRefresh();
  }

  int _page = 1;

  Future<List<BankModel>> getListBank(
    String? search, {
    bool isMore = false,
  }) async {
    // emit(state.copyWith(status: CubitStatus.loading));
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }
    final res = await _repo.getListBank(search, _page);
    if (res.code == 200) {
      // emit(
      //   state.copyWith(
      //     status: CubitStatus.success,
      //     listBank: res.data,
      //   ),
      // );
      return res.data ?? [];
    } else {
      // emit(state.copyWith(status: CubitStatus.error));
      return [];
    }
  }

  void getListMyBank({bool selectDefault = false}) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.getListMyBank();
    if (res.code == 200) {
      emit(
        state.copyWith(
          isLoading: false,
          listMyBank: res.data,
          myBankSelect: selectDefault ? res.data?.first : null,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectBank(BankModel? value) {
    emit(state.copyWith(bankSelect: value, status: CubitStatus.success));
    print(state.bankSelect?.name);
  }

  void selectWithdrawBank(MyBankModel? value) {
    emit(state.copyWith(myBankSelect: value));
  }

  void createBankAccount(String bankNumber, String name) async {
    // emit(state.copyWith(status: CubitStatus.loading));
    final replaceNumber = bankNumber.replaceAll(" ", "");
    final res = await _repo.createBankAccount(
      name,
      replaceNumber,
      state.bankSelect?.id,
      state.isDefault,
    );
    // if (res.code == 200) {
    //   emit(
    //     state.copyWith(status: CubitStatus.sendSuccess, message: res.message),
    //   );
    // } else {
    //   emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
    // }
  }

  void onSelectDefault(bool value) {
    emit(state.copyWith(isDefault: value));
  }

  void sendRequestChangeToken(String text) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.sendRequestChangeToken(text);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: CubitStatus.success,
          message: res.message,
          token: res.data,
        ),
      );
    } else {
      emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
    }
  }

  void setTab(int tab) {
    emit(state.copyWith(index: tab));
  }

  Future<bool> requestWithdraw(int money) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final bankId = state.myBankSelect?.id ?? 0;
    final res = await _repo.requestWithdraw(money, bankId);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: CubitStatus.sendSuccess,
          message: res.message,
        ),
      );
      return true;
    } else {
      emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
      return false;
    }
  }

  void verificationToken(String token) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.verificationToken(token);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: CubitStatus.success,
          message: null,
        ),
      );
    } else {
      emit(state.copyWith(status: CubitStatus.error, message: res.message));
    }
  }

  void getBankDetail(int id) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repo.getBankDetail(id);
    if (res.code == 200) {
      bankDetail = res.data;
      emit(state.copyWith(isLoading: false, status: CubitStatus.update));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void deleteBankAccount() {}

  void updateBankAccount(String bankNumber, String name) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final replaceNumber = bankNumber.replaceAll(" ", "");
    final res = await _repo.updateBankAccount(
      name,
      replaceNumber,
      state.bankSelect?.id,
      state.isDefault,
      bankDetail?.id,
    );
    if (res.code == 200) {
      emit(
        state.copyWith(status: CubitStatus.sendSuccess, message: res.message),
      );
    } else {
      emit(state.copyWith(status: CubitStatus.loaded, message: res.message));
    }
  }

  void editBankSelect() {
    selectBank(null);
  }
}
