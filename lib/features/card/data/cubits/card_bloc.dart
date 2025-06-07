import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/features/card/data/models/my_card_model.dart';
import 'package:bpg_retail/features/card/data/repositories/card_repository.dart';
import 'package:bpg_retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:bpg_retail/features/wallet/data/repositories/wallet_repository.dart';

import '../../../../core/base/cubit_state.dart';
import '../../../../core/utilities/enum.dart';
import '../models/card_model.dart';

class CardBloc extends Cubit<CubitState> {
  CardBloc() : super(CubitState());
  final List<CardModel> cards = [];
  List<MyCardModel> myCards = [];
  final _cartRepo = CardRepository();
  final _walletRepo = WalletRepository();
  int _page = 1;
  num totalPrice = 0;
  num totalWalletPrice = 0;
  // num saveCardProfit = 0;
  // DateTime currentDate = DateTime.now();

  void getCards({bool isMore = false}) async {
    if (!isMore) {
      _page = 1;
      cards.clear();
    } else {
      _page++;
    }
    emit(state.copyWith(status: CubitStatus.loading));

    final res = await _cartRepo.cards(_page);
    cards.addAll(res.data ?? []);
    if (res.data.validator.isEmpty && isMore) {
      _page--;
    }

    emit(state.copyWith(status: CubitStatus.success));
  }

  void getMyCard() async {
    // print("=======getMyCard");
    // myCards.clear();
    emit(state.copyWith(status: CubitStatus.loading));

    final res = await _cartRepo.myCards();
    // myCards.addAll(res.data ?? []);
    myCards = res.data ?? [];
    myCards.map(
      (cardGroup) {
        cardGroup.userCards?.map((card) {
          final secondProfit = card.price.validator *
              (card.cashback.validator / 100) /
              (24 * 3600);

          DateTime lastSaveTime = DateTime.now().toUtc();

          if (card.lastScanAt != null) {
            lastSaveTime = (card.updatedAt!).toUtc();
            // lastSaveTime = (card.lastScanAt!).toUtc();
          } else {
            lastSaveTime = (card.createdAt!).toUtc();
          }
          // print("=====Card===lastSaveTime====${lastSaveTime.toString()}");

          // Tính khoảng thời gian giữa hai mốc
          final Duration difference = DateTime.now().difference(lastSaveTime);

          // Quy đổi ra giây
          final int secondsDifference = difference.inSeconds;
          // print(
          //   "CardsecondsDifference=====$secondsDifference=====$secondProfit",
          // );
          card.totalCashback =
              card.totalCashback.validator + secondProfit * secondsDifference;
          // print("======${card.id}${card.totalCashback}");
          // saveCardProfit = saveCardProfit + secondProfit * secondsDifference;
        }).toList();
      },
    ).toList();

    emit(state.copyWith(status: CubitStatus.success));
  }

  num get amount {
    num price = 0;

    for (final element in myCards) {
      final itemPrice = element.userCards?.fold(
        0.0,
        (value, card) {
          return value +
              ((card.price.validator * card.cashback.validator) / 100);
        },
      );
      price += itemPrice.validator;
    }
    return price / (24 * 60 * 60);
  }

  void calculatorCashBack() {
    emit(state.copyWith(status: CubitStatus.loadMore));
    totalPrice = 0;
    num totalCashback = 0;
    myCards.map(
      (cardGroup) {
        cardGroup.userCards?.map((card) {
          final secondProfit = card.price.validator *
              (card.cashback.validator / 100) /
              (24 * 3600);

          final isOver = (card.totalCashback.validator + secondProfit) >
              card.price.validator;
          if (!isOver) {
            card.totalCashback = card.totalCashback.validator + secondProfit;
          } else {
            card.totalCashback = card.price;
          }
          totalCashback = totalCashback + card.totalCashback.validator;
        }).toList();
      },
    ).toList();
    totalPrice = totalWalletPrice + totalCashback;

    emit(state.copyWith(status: CubitStatus.loaded));
  }

  void getWallet() async {
    final res = await _walletRepo.wallets();
    if (res.code == 200) {
      totalWalletPrice = res.data!
          .fold(0, (num pre, element) => pre + element.balance.validator);
    }
  }
}
