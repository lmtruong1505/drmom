import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'package:bpg_retail/features/card/data/models/bank_model.dart';
import 'package:bpg_retail/features/cart/data/bloc/asbc_cart_buy_cubit.dart';
import 'package:bpg_retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:bpg_retail/features/wallet/data/models/card_wallet_model.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

@RoutePage()
class PayymentMethodPage extends StatefulWidget {
  const PayymentMethodPage({
    super.key,
    this.onChange,
    this.totalPrice,
    this.walletType,
    this.paymentSelect,
    this.bank,
  });
  final void Function(PaymentMethodEnum? method, num? wallet)? onChange;
  final num? totalPrice;
  final num? walletType;
  final PaymentMethodEnum? paymentSelect;
  final BankModel? bank;

  @override
  State<PayymentMethodPage> createState() => _PayymentMethodPageState();
}

class _PayymentMethodPageState extends State<PayymentMethodPage> {
  @override
  void initState() {
    super.initState();
    paymentMethod = widget.paymentSelect;
    wallletSelect = widget.walletType;
    setState(() {});
  }

  PaymentMethodEnum? paymentMethod;
  // CardWalletModel? wallletSelect;
  num? wallletSelect;
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final walletBloc = context.read<WalletCubit>();

    walletBloc.setWallet((wallletSelect ?? 0));
    return BaseScreen(
      title: "Phương thức thanh toán",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Assets.images.imCreditCard.svg(),
                8.width,
                const Text(
                  "Bạn có thể lựa chọn một trong các phương thức thanh toán sau đây:",
                  style: s14w400,
                ).expanded(),
              ],
            ),
            8.height,
            const Text(
              "Ví của tôi",
              style: s14w500,
            ),
            8.height,
            walletList(walletBloc.wallets),
            8.height,
            walletList(walletBloc.walletsAwait),
            8.height,
            const Text(
              "Hình thức khác",
              style: s14w500,
            ),
            8.height,
            GestureDetector(
              onTap: () {
                paymentMethod = PaymentMethodEnum.banking;
                setState(() {});
                // widget.bloc.pickPaymentMethod(PaymentMethodEnum.banking);
              },
              child: BaseContainer(
                borderColor: paymentMethod == PaymentMethodEnum.banking
                    ? AppColors.main
                    : null,
                padding: 16.pading,
                child: Row(
                  children: [
                    Assets.icons.icBanking.svg(),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Chuyển khoản ngân hàng",
                          style: s14w500,
                        ),
                        4.height,
                        Text.rich(
                          TextSpan(
                            text: widget.bank?.code ?? '-',
                            style: s12w400,
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: 4.pading,
                                  child: const Icon(
                                    Icons.circle,
                                    size: 6,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.bank?.accountNumber ?? '-',
                                style: s14w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).expanded(),
                  ],
                ),
              ),
            ),
          ],
        ).padding(16.pading),
      ),
      bottomNavigationBar: Container(
        padding: 16.padingHor + 16.padingTop,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ExtraButton(
                  title: "Quay lại",
                  onTap: () => navigator.pop(),
                  largeButton: true,
                ).expanded(),
                16.width,
                MainButton(
                  title: "Chọn",
                  onTap: () {
                    widget.onChange?.call(paymentMethod, wallletSelect);
                    navigator.pop(result: true);
                  },
                  largeButton: true,
                ).expanded(),
              ],
            ),
            if (Platform.isIOS)
              SizedBox(height: MediaQuery.of(context).padding.bottom / 2),
          ],
        ),
      ),
    );
  }

  ListView walletList(List<CardWalletModel> wallets) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return _walltetItem(wallet, context);
      },
      separatorBuilder: (context, index) {
        final wallet = wallets[index];
        return Visibility(visible: wallet.type != 3, child: 8.height);
      },
      itemCount: wallets.length,
    );
  }

  Widget _walltetItem(CardWalletModel wallet, BuildContext context) {
    final isDissable = (widget.totalPrice ?? 0) > (wallet.balance ?? 0);
    final color = isDissable ? AppColors.greyAA : null;
    return Visibility(
      visible: wallet.type != 3,
      child: GestureDetector(
        onTap: () {
          if (isDissable) {
            Toast.showToast('Số dư không đủ', context);
          } else {
            paymentMethod = PaymentMethodEnum.wallet;
            wallletSelect = wallet.type;
            setState(() {});
            // .pickPaymentMethod(PaymentMethodEnum.wallet, wallet: wallet);
          }
        },
        child: BaseContainer(
          borderColor: paymentMethod == PaymentMethodEnum.wallet &&
                  wallet.type == wallletSelect
              ? AppColors.main
              : null,
          padding: 16.pading,
          child: Row(
            children: [
              wallet.logo ?? const SizedBox.shrink(),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    wallet.title,
                    style: s14w500.copyWith(
                      color: color,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Số dư: ",
                      style: s12w400.copyWith(
                        color: color,
                      ),
                      children: [
                        TextSpan(
                          text: formatCurrency(wallet.balance ?? 0),
                          style: s14w500.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }
}
