import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/card/data/models/card_model.dart';
import 'package:bpg_retail/features/card/data/models/my_card_model.dart';
import 'package:bpg_retail/features/card/presentation/components/card_item.dart';
import 'package:bpg_retail/features/wallet/data/cubits/wallet_cubit.dart';

import '../../../../core/widgets/base/base_loading.dart';
import '../../data/cubits/card_bloc.dart';

class TabMyCard extends StatefulWidget {
  const TabMyCard({super.key});

  @override
  State<TabMyCard> createState() => _TabMyCardState();
}

class _TabMyCardState extends State<TabMyCard>
    with AutomaticKeepAliveClientMixin {
  // final bloc = CardBloc();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    refreshData();
    // bloc
    //   ..getWallet()
    //   ..getMyCard();
    // context.read<WalletCubit>().getWallets();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      context.read<CardBloc>().calculatorCashBack();
    });
  }

  void refreshData() {
    // _timer.cancel();
    final cardBloc = context.read<CardBloc>();
    final walletBlc = context.read<WalletCubit>();
    cardBloc
      ..getMyCard()
      ..getWallet();

    walletBlc.getWallets();
    Future.delayed(const Duration(seconds: 1), () {
      final amount = cardBloc.amount.toDouble();
      // print("===lãi theo s======$amount");
      walletBlc.updateBalance(type: 0, amount: amount);
      cardBloc.calculatorCashBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CardBloc>();
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        refreshData();

        // bloc
        //   ..getWallet()
        //   ..getMyCard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            BlocConsumer<CardBloc, CubitState>(
              listener: (context, state) {
                if (state.status == CubitStatus.success) {
                  startTimer();
                }
              },
              bloc: bloc,
              builder: (context, state) {
                if (state.status == CubitStatus.loading && bloc.cards.isEmpty) {
                  return const Center(child: BaseLoading());
                }
                return Column(
                  children: [
                    _totalMoney(),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: 0.padingVer,
                      itemBuilder: (context, index) => myCard(
                        model: bloc.myCards[index],
                      ),
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: bloc.myCards.length,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding _totalMoney() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: 16.radius,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF24C6DC),
              Color(0xFF514A9D),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Tổng tiền",
                style: s14w400.copyWith(color: AppColors.white),
              ),
            ),
            8.height,
            BlocBuilder<WalletCubit, CubitState>(
              bloc: context.read<WalletCubit>(),
              builder: (context, state) {
                return Center(
                  child: Text(
                    context
                        .read<WalletCubit>()
                        .totalWallet
                        .balance
                        .toPrice(type: ' VNĐ'),
                    style: s24w700.copyWith(color: AppColors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget myCard({required MyCardModel model}) {
    return CarouselSlider.builder(
      itemCount: model.userCards.validator.length,
      itemBuilder: (context, index, realIndex) {
        final card = CardModel(
          id: model.cardInfor?.id,
          title: model.cardInfor?.title,
          image: model.cardInfor?.image,
          cashback: model.userCards![index].cashback,
          price: model.userCards![index].price,
          priceCurrent: model.userCards![index].totalCashback ?? 0,
          isMyCard: true,
          createdAt: model.userCards![index].createdAt,
          code: model.userCards![index].code,
        );
        return CardItem(model: card, index: index + 1);
      },
      options: CarouselOptions(
        enableInfiniteScroll: false,
        viewportFraction: .95,
        height: 280,
      ),
    );
    // return PageView.builder(
    //   itemBuilder: (context, index) {
    //     final card = CardModel(
    //       id: model.cardInfor?.id,
    //       title: model.cardInfor?.title,
    //       image: model.cardInfor?.image,
    //       cashback: model.userCards![index].cashback,
    //       price: model.userCards![index].price,
    //       priceCurrent: model.userCards![index].totalCashback ?? 0,
    //       isMyCard: true,
    //     );
    //     return CardItem(model: card);
    //   },
    //   itemCount: model.userCards.validator.length,
    // ).size(height: 312);
  }

  @override
  bool get wantKeepAlive => false;
}
