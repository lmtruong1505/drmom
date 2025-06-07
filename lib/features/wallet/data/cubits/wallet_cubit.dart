import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/wallet/data/models/card_wallet_model.dart';
import 'package:bpg_retail/features/wallet/data/repositories/wallet_repository.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

import '../../../../core/base/cubit_state.dart';

class WalletCubit extends Cubit<CubitState> {
  WalletCubit() : super(CubitState());
  final _repo = WalletRepository();

  final now = DateTime.now().toUtc();
  num withdrawMoney = 0;
  CardWalletModel? _wallet;
  CardWalletModel get wallet => _wallet ?? wallets.first;
  void setWallet(num? type) {
    _wallet = [...wallets, ...walletsAwait, totalWallet].firstWhere(
      (val) => val.type == type,
      orElse: () => wallet,
    );
    emit(state.copyWith(status: CubitStatus.success));
  }

  CardWalletModel? getWallet(num? type) =>
      _wallet = walletsAwait.firstOrNullWhere((val) => val.type == type);

  CardWalletModel totalWallet = CardWalletModel(
    logo: Assets.icons.icWalletCrashback.svg(),
    colors: [
      const Color(0xFF1818D0),
      const Color(0xFFFF00CC),
    ],
    title: 'Tổng tiền',
    opacity: 0.6,
    type: 5,
  );
  final List<CardWalletModel> wallets = [
    CardWalletModel(
      logo: Assets.icons.icWalletCrashback.svg(),
      colors: [
        const Color(0xFF1818D0),
        const Color(0xFFFF00CC),
      ],
      title: 'Ví mua hàng',
      opacity: 0.6,
      type: 1,
    ),
    CardWalletModel(
      logo: Assets.icons.icWalletDissable.svg(),
      colors: [
        const Color(0xFF2193B0),
        const Color(0xFF6DD5ED),
      ],
      title: 'Ví quà tặng',
      opacity: 0.8,
      type: 2,
    ),
  ];
  final List<CardWalletModel> walletsAwait = [
    CardWalletModel(
      logo: Assets.icons.icWalletGift.svg(),
      colors: [
        const Color(0xFF2A0845),
        const Color(0xFF6441A5),
      ],
      title: 'Ví cashback',
      opacity: 0.8,
      textBtn: 'Xác nhận tiêu dùng',
      // subTitle: '80% sang ví tiêu dùng, 20% sang ví rút tiền',
      onTap: () {},
      type: 3,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      lastScanAt: DateTime.now().toUtc(),
    ),
    CardWalletModel(
      logo: Assets.icons.icWalletActive.svg(),
      colors: [
        const Color(0xFF1CB5E0),
        const Color(0xFF000046),
      ],
      title: 'Ví rút tiền',
      opacity: 0.6,
      textBtn: 'Chốt nhận tiền lời',
      onTap: () {},
      type: 0,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      lastScanAt: DateTime.now().toUtc(),
    ),
  ];

  void getWallets() async {
    // print("=======getWallet");
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.wallets();
    for (int i = 0; i < wallets.length; i++) {
      final wallet = res.data?.firstWhere(
        (val) => val.type == wallets[i].type,
        orElse: () => wallets[i],
      );
      wallets[i].title = wallet?.title ?? "";
      wallets[i].balance = wallet?.balance;
      wallets[i].percentShopping = wallet?.percentShopping;
      wallets[i].percentWithdraw = wallet?.percentWithdraw;
      // total = total + (wallet?.balance ?? 0);
    }

    for (int i = 0; i < walletsAwait.length; i++) {
      final wallet = res.data?.firstWhere(
        (val) => val.type == walletsAwait[i].type,
        orElse: () => walletsAwait[i],
      );
      walletsAwait[i].title = wallet?.title ?? "";
      walletsAwait[i].balance = wallet?.balance;
      walletsAwait[i].percentShopping = wallet?.percentShopping;
      walletsAwait[i].percentWithdraw = wallet?.percentWithdraw;
      walletsAwait[i].createdAt = wallet?.createdAt;
      walletsAwait[i].updatedAt = wallet?.updatedAt;
      walletsAwait[i].lastScanAt = wallet?.lastScanAt;
      if (walletsAwait[i].percentShopping != null ||
          walletsAwait[i].percentWithdraw != null) {
        walletsAwait[i].subTitle =
            '${(walletsAwait[i].percentWithdraw == 0) ? "" : "${walletsAwait[i].percentWithdraw.checkDecimal()}% sang ví rút tiền, "} '
            '${walletsAwait[i].percentShopping.checkDecimal()}% sang ví mua hàng';
      }
      // total = total + (wallet?.balance ?? 0);
    }
    // totalWallet.balance = total;
    // print('======walletAll${totalWallet.balance}');

    emit(state.copyWith(status: CubitStatus.success));
  }

  // CardWalletModel get wallet => _wallet ?? walletAll;

  void updateBalance({
    required int type,
    required double amount,
  }) {
    final now = DateTime.now().toUtc();
    // print("=====now====${now.toString()}");
    DateTime lastSaveTime = DateTime.now().toUtc();

    for (int i = 0; i < walletsAwait.length; i++) {
      if (walletsAwait[i].lastScanAt != null) {
        lastSaveTime = (walletsAwait[i].lastScanAt!).toUtc();
      } else if (walletsAwait[i].updatedAt != null) {
        lastSaveTime = (walletsAwait[i].updatedAt!).toUtc();
      }
      // print("=====Wallet===lastSaveTime====${lastSaveTime.toString()}");
      final Duration difference = now.difference(lastSaveTime);

      final int secondsDifference = difference.inSeconds;
      // print("WalletsecondsDifference=====$secondsDifference");
      if (walletsAwait[i].type == type) {
        walletsAwait[i].totalCashback = 0;
        walletsAwait[i].totalCashback = amount * secondsDifference;

        // totalWallet.balance =
        //     (totalWallet.balance ?? 0) + amount * secondsDifference;
        // print("=x=x==x=x==${totalWallet.balance}");
      }
    }
    emit(state.copyWith(status: CubitStatus.success));
  }

  void updateProfit({
    required int type,
    required double amount,
  }) {
    totalWallet.balance = 0;
    for (int i = 0; i < walletsAwait.length; i++) {
      if (walletsAwait[i].type == type) {
        walletsAwait[i].totalCashback =
            walletsAwait[i].totalCashback.validator + amount;
      }
    }
    calculatorBalanceTotalWallet();

    emit(state.copyWith(status: CubitStatus.success));
  }

  void withdrawBalance({
    required int type,
    required num? price,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.updateBalanceWallets(price ?? 0);
    if (res.code == 200) {
      withdrawMoney = price ?? 0;
      emit(state.copyWith(status: CubitStatus.sendSuccess));
    } else {
      emit(
        state.copyWith(
          status: CubitStatus.sendFaild,
          message: res.message,
        ),
      );
    }
  }

  void calculatorBalanceTotalWallet() {
    for (int i = 0; i < walletsAwait.length; i++) {
      final wallet = walletsAwait[i];

      totalWallet.balance = (totalWallet.balance ?? 0) +
          wallet.balance.validator +
          wallet.totalCashback.validator;
    }
    for (int i = 0; i < wallets.length; i++) {
      final wallet = wallets[i];

      totalWallet.balance =
          (totalWallet.balance ?? 0) + wallet.balance.validator;
    }
  }

  void confirmCashback() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.confirmCashback();
    if (res.code == 200) {
      emit(state.copyWith(status: CubitStatus.update));
    } else {
      emit(state.copyWith(status: CubitStatus.sendFaild));
    }
  }
}
