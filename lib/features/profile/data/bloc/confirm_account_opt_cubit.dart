import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/authentication/data/repositories/authentication_repository.dart';

@Injectable()
class ConfirmAccountOtpCubit extends Cubit<CubitState> {
  ConfirmAccountOtpCubit(this._authRepo) : super(CubitState());
  AuthenticationRepository _authRepo;
  bool isPhoneCount = false;
  bool isEmailCount = false;
  bool isPhoneValid = false;
  bool isEmailValid = false;
  int tabIndex = 0;
  bool isDisable = true;
  bool isActivePhone = false;
  Timer? _timer;
  int countTime = 120;
  final _debounce = Debouncer();

  void changeTab(int index) {
    tabIndex = index;
    emit(state.copyWith(status: CubitStatus.success));
  }

  void setDisable(bool value) {
    isDisable = value;
    emit(state.copyWith(status: CubitStatus.update));
  }

  void isChangeStatus() {
    emit(state.copyWith(status: CubitStatus.update));
  }

  void setSendOTP(bool value, {bool isPhone = true}) {
    _debounce.run(
      () {
        if (isPhone) {
          isPhoneValid = value;
        } else {
          isEmailValid = value;
        }
      },
    );
  }

  void startTimer({bool isPhone = true}) {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (isPhone) {
      isPhoneCount = true;
      isEmailCount = false;
    } else {
      isEmailCount = true;
      isPhoneCount = false;
    }
    countTime = 120;

    emit(state.copyWith(status: CubitStatus.update));
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countTime == 0) {
          _timer!.cancel();
          emit(state.copyWith(status: CubitStatus.update));
        } else {
          countTime--;
          emit(state.copyWith(status: CubitStatus.update));
        }
      },
    );
  }

  final navigator = getIt.get<AppNavigator>();
  void setActiveSendOTP(bool bool) {}

  void verifyBankAccout(String value, String otp) async {
    if (tabIndex == 0) {
      emit(state.copyWith(status: CubitStatus.loading));
      final res = await _authRepo.verifyBankAccout(value, otp);
      if (res.code == 200) {
        navigator.pop();
        navigator.pop(result: true);
        emit(state.copyWith(status: CubitStatus.sendSuccess));
      } else {
        emit(state.copyWith(status: CubitStatus.sendFaild));
      }
    }
    emit(state.copyWith(status: CubitStatus.sendFaild));
  }
}
