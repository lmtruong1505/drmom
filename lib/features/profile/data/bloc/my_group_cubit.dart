import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bpg_retail/features/profile/data/bloc/my_group_state.dart';
import 'package:bpg_retail/features/profile/data/models/my_group_model.dart';
import 'package:bpg_retail/features/profile/data/models/referall_model.dart';
import 'package:bpg_retail/features/profile/data/repositories/my_group_repository.dart';

@Injectable()
class MyGroupCubit extends Cubit<MyGroupState> {
  MyGroupCubit(this._repo, this._authenticationRepository)
      : super(const MyGroupState());
  final MyGroupRepository _repo;
  final AuthenticationRepository _authenticationRepository;

  int page = 1;
  String? key;
  final debounce = Debouncer();
  int total = 0;
  MyGroupModel? refferenceInfor;
  ReferallModel? refference;
  String? message;
  bool isMore = true;

  void getListMember({MyGroupModel? member}) async {
    try {
      if (page == 1) {
        emit(state.copyWith(status: CubitStatus.loading));
      } else {
        emit(state.copyWith(status: CubitStatus.loadMore));
      }
      if (isMore) {
        final res = await _repo.getListMember(key, page, id: member?.id);
        if (res.data["code"] == 200) {
          final list = (res.data["data"] as List)
              .map((e) => MyGroupModel.fromJson(e))
              .toList();
          isMore = list.length == 10;
          emit(
            state.copyWith(
              listGroup: (state.listGroup ?? []) + list,
              total: res.data["count"],
            ),
          );
        }
        emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, status: CubitStatus.loaded));
    }
  }

  void onSearch(String keySearch, MyGroupModel? member) {
    key = keySearch;
    debounce.run(() => onRefesh(member));
  }

  void onLoadMore(MyGroupModel? member) {
    page = page + 1;
    getListMember(member: member);
  }

  void onRefesh(MyGroupModel? member) {
    page = 1;
    isMore = true;
    emit(state.copyWith(listGroup: []));
    getListMember(member: member);
  }

  void getMyReferrer({MyGroupModel? member}) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final id = 1;
    try {
      final res = await _repo.getMyReferrer(member?.id ?? id);
      if (res.code == 200) {
        refferenceInfor = res.data;
        emit(state.copyWith(status: CubitStatus.success));
      } else {
        emit(state.copyWith(status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  Future<void> verifyReferralCode(String? code) async {
    final id = 1;
    try {
      emit(state.copyWith(status: CubitStatus.loading));
      final res = await _authenticationRepository.verifyReferralCode(code ?? "",
          id: id);
      if (res.code == 200) {
        message = null;
        refference = res.data;
        emit(state.copyWith(status: CubitStatus.success));
      } else {
        message = res.message;
        emit(state.copyWith(status: CubitStatus.loaded));
      }
    } catch (e) {
      message = "Mã giới thiệu không hợp lệ!";
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  void updateReferralCode(String code) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final id = 1;
    try {
      final res = await _repo.updateReferrer(code, id);
      if (res.code == 200) {
        emit(state.copyWith(status: CubitStatus.sendSuccess));
      } else {
        emit(state.copyWith(status: CubitStatus.sendFaild));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.sendFaild));
    }
  }

  void clearRefference() {
    message = null;
    refference = null;
  }

  void setWarningMessage() {
    message = null;
    emit(state.copyWith(status: CubitStatus.loading));
    message = 'Không thể nhập mã của chính mình!';
    emit(state.copyWith(status: CubitStatus.success));
  }
}
