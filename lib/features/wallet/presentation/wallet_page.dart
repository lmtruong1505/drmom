import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/core/core.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:BGP_Retail/core/widgets/toast/toast.dart';
import 'package:BGP_Retail/core/widgets/toast/toast_position.dart';
import 'package:BGP_Retail/features/card/data/cubits/card_bloc.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/payment_detail_sreen.dart';
import 'package:BGP_Retail/features/wallet/data/cubits/withdraw_wallet_cubit.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';
import '../data/cubits/wallet_cubit.dart';
import '../data/models/card_wallet_model.dart';

@RoutePage()
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final indexBloc = IndexCubit();
  final withDrawBloc = WithdrawWalletCubit();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey();
  bool canPress = true;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    final cardBloc = context.read<CardBloc>();
    final walletBlc = context.read<WalletCubit>();
    cardBloc.getMyCard();

    walletBlc.getWallets();
    Future.delayed(const Duration(seconds: 1), () {
      final amount = cardBloc.amount.toDouble();
      walletBlc.updateBalance(type: 0, amount: amount);
    });
  }

  @override
  void didChangeDependencies() {
    refreshData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final walletBloc = context.read<WalletCubit>();
    // final cardBloc = context.read<CardBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<WithdrawWalletCubit, CubitState>(
          bloc: withDrawBloc,
          listener: (context, state) {
            if (state.status == CubitStatus.loading) {
              showLoading();
            }

            if (state.status != CubitStatus.loading) {
              EasyLoading.dismiss();
              Toast.showToast(
                state.message,
                context,
                toastPosition: ToastPosition.BOTTOM,
              );
            }
            if (state.status == CubitStatus.success) {}
          },
        ),
      ],
      child: BaseScreen(
        title: 'Ví của tôi',
        body: BlocConsumer<WalletCubit, CubitState>(
          listener: (context, state) {
            final status = state.status;
            if (status == CubitStatus.update) {
              refreshData();
            } else if (status == CubitStatus.sendSuccess) {
              final withdrawMoney =
                  (walletBloc.withdrawMoney).toPrice(type: ' đ');
              DialogUtils.showSuccessDialog(
                context,
                title: "Ví rút tiền +$withdrawMoney",
                content:
                    "Chúc mừng bạn đã chốt lời thành công! $withdrawMoney được cộng vào ví rút tiền.",
                hasButtonBack: false,
                accept: () => nav.pop(),
                mainTitle: "Đóng",
              );
              refreshData();
            } else if (status == CubitStatus.sendFaild) {
              DialogUtils.showErrorDialog(context, content: state.message);
              refreshData();
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: () async {
                refreshData();
              },
              child: Container(
                height: context.height,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      24.height,
                      // BlocConsumer<IndexCubit, int>(
                      //   bloc: indexBloc,
                      //   listener: (context, state) {
                      //     _tabController.animateTo(
                      //       state,
                      //       duration: 200.milliseconds,
                      //     );
                      //   },
                      //   builder: (context, state) {
                      //     return Row(
                      //       children: [
                      //         TabButton(
                      //           onTap: () {
                      //             indexBloc.set(0);
                      //           },
                      //           title: 'Ví hiện có',
                      //           isActive: state == 0,
                      //         ).expanded(),
                      //         16.width,
                      //         TabButton(
                      //           onTap: () {
                      //             indexBloc.set(1);
                      //           },
                      //           title: 'Ví chờ',
                      //           isActive: state == 1,
                      //         ).expanded(),
                      //       ],
                      //     );
                      //   },
                      // ).padding(16.padingHor),

                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: 16.padingHor,
                        itemBuilder: (context, index) =>
                            _cardWallet(walletBloc.wallets[index], state),
                        separatorBuilder: (context, index) => 16.height,
                        itemCount: walletBloc.wallets.length,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: 16.pading,
                        itemBuilder: (context, index) {
                          final wallet = walletBloc.walletsAwait[index];
                          return GestureDetector(
                            onTap: () {
                              // print('_cardWallet${wallet.balance.validator}');
                              // if (wallet.balance.validator > 0) {
                              //   withDrawBloc.withdraw(
                              //     wallet.type!,
                              //     title: wallet.textBtn ?? "",
                              //   );
                              // }
                            },
                            child: _cardWallet(wallet, state),
                          );
                        },
                        separatorBuilder: (context, index) => 16.height,
                        itemCount: walletBloc.walletsAwait.length,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cardWallet(CardWalletModel model, CubitState state) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        borderRadius: 16.radius,
        gradient: LinearGradient(
          colors:
              model.colors.map((e) => e.withOpacity(model.opacity)).toList(),
        ),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.white.withOpacity(0.8),
                radius: 56 / 2,
                child: ImageGradient.linear(
                  image: Assets.icons.icWalletPng.image(),
                  colors: model.colors,
                ).padding(16.pading),
              ),
              16.width,
              Text(
                model.title,
                overflow: TextOverflow.ellipsis,
                style: s14w500.copyWith(color: AppColors.white),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model.balance.toPrice(type: ' đ'),
                    overflow: TextOverflow.ellipsis,
                    style: s16w700.copyWith(color: AppColors.white),
                  ),
                  if ((model.type == 0))
                    Row(
                      children: [
                        Text(
                          "Có thể nhận: ",
                          overflow: TextOverflow.ellipsis,
                          style: s12w500.copyWith(color: AppColors.white),
                        ),
                        Text(
                          model.totalCashback.toPrice(type: ' đ'),
                          overflow: TextOverflow.ellipsis,
                          style: s12w500.copyWith(color: AppColors.green_1),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          // if (model.onTap != null || model.subTitle != null)
          //   Divider(
          //     height: 18 * 2,
          //     color: AppColors.white.withOpacity(0.8),
          //   ),
          if (model.onTap != null) ...[
            // if (model.subTitle != null)
            16.height,
            CommonButton(
              onTap: () {
                if (!canPress) {
                  return;
                }
                _onAwaitWallet(model);
              },
              title: model.textBtn ?? "",
              titleColor: AppColors.white,
              buttonColor: AppColors.white.withOpacity(0.2),
              radius: 99,
              padding: 16.padingHor + 10.padingVer,
            ),
          ],
          if (model.subTitle != null) ...[
            8.height,
            Text(
              model.subTitle ?? '',
              style: s12w400.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onAwaitWallet(CardWalletModel model) {
    final walletBloc = context.read<WalletCubit>();
    canPress = false;
    Future.delayed(1.seconds, () => canPress = true);

    if (model.type == 0) {
      if (model.totalCashback == 0) {
        Future.delayed(1.seconds, () => canPress = true);
        DialogUtils.showErrorDialog(
          context,
          content: 'Bạn không thể chốt khi chưa có tiền lời',
        );
      } else {
        Future.delayed(3.seconds, () => canPress = true);
        DialogUtils.showWarningDialog(
          context,
          content: 'Bạn có muốn chốt nhận tiền lời',
          isDouble: true,
          mainTap: () {
            nav.pop();
            walletBloc.withdrawBalance(
              type: 0,
              price: model.totalCashback ?? 0,
            );
          },
        );
      }
    } else if (model.type == 3) {
      if (model.balance == 0) {
        Future.delayed(1.seconds, () => canPress = true);
        DialogUtils.showErrorDialog(
          context,
          content: 'Bạn không thể xác nhận tiêu dùng khi chưa có số dư',
        );
      } else {
        Future.delayed(3.seconds, () => canPress = true);
        DialogUtils.showWarningDialog(
          context,
          content: 'Bạn có muốn xác nhận tiêu dùng',
          isDouble: true,
          mainTap: () {
            walletBloc.confirmCashback();
            nav.pop();
          },
        );
      }
    }
  }
}
