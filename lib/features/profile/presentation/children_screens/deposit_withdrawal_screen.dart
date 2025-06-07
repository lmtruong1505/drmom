import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/dialog_utils.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/image_utils.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/main_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/core/widgets/common/title_required.dart';
import 'package:bpg_retail/core/widgets/text_and_text.dart';
import 'package:bpg_retail/core/widgets/textfield/pin_input_textfield.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/features/profile/data/bloc/deposit_withdraw_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/features/profile/data/models/deposit_qr_code_model.dart';
import 'package:bpg_retail/features/wallet/data/cubits/wallet_cubit.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class DepositWithdrawScreen extends StatefulWidget {
  const DepositWithdrawScreen({super.key, required this.tab});
  final int tab;

  @override
  State<DepositWithdrawScreen> createState() => _DepositWithdrawScreenState();
}

class _DepositWithdrawScreenState extends State<DepositWithdrawScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    inputMoneyCtrl = TextEditingController();
    withdrawMoneyCtrl = TextEditingController();
    _tabController.animateTo(widget.tab);
    bloc.setTab(widget.tab);
    bloc.getListMyBank(selectDefault: true);
    walletBloc.getWallets();
  }

  late TabController _tabController;
  final bloc = getIt.get<DepositWithdrawCubit>();
  final navigator = getIt.get<AppNavigator>();
  final walletBloc = WalletCubit();
  late TextEditingController inputMoneyCtrl;
  late TextEditingController withdrawMoneyCtrl;
  final key1 = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();

  final NumberFormat _formatter = NumberFormat("#,###", "vi_VN");

  // Hàm để định dạng số tiền khi nhập
  String _formatCurrency(String value) {
    // Xóa ký tự không phải số
    final String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) return '';

    // Chuyển thành số nguyên và định dạng
    final int parsedValue = int.parse(cleanValue);
    return '${_formatter.format(parsedValue)}đ';
  }

  // Hàm xử lý thay đổi khi nhập liệu
  void _onTextChanged(String value, TextEditingController ctrl) {
    final String formattedValue = _formatCurrency(value);

    // Cập nhật TextField mà không bị nhảy con trỏ
    ctrl.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DepositWithdrawCubit>(
      create: (context) => bloc,
      child: BlocListener<DepositWithdrawCubit, DepositWithdrawState>(
        listenWhen: (previous, current) => previous.index != current.index,
        listener: (context, state) {
          _tabController.animateTo(state.index ?? 0);
        },
        child: BaseScreen(
          title: 'Nạp/ Rút tiền',
          body: Stack(
            fit: StackFit.expand,
            children: [
              Assets.images.bgScreen.image(
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: context.width,
                height: context.height,
                child: _bodyView(),
              ),
            ],
          ),
          bottomNavigationBar: _bottomBar(),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return BlocConsumer<DepositWithdrawCubit, DepositWithdrawState>(
      listener: (context, state) {
        if (state.status == CubitStatus.sendSuccess && state.index == 1) {}
      },
      builder: (context, state) {
        final isDeposit = state.index == 0;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ExtraButton(
            largeButton: false,
            title: state.index == 0 ? 'Nạp tiền' : "Rút tiền",
            color: AppColors.white,
            bgColor: AppColors.main,
            borderColor: AppColors.main,
            onTap: () {
              if (isDeposit) {
                if (!key1.currentState!.validate()) {
                  return;
                }
                final formattedValue =
                    inputMoneyCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
                final amount = int.tryParse(formattedValue) ?? 0;
                bloc.createDeposit(amount);
              } else {
                if (!key2.currentState!.validate()) {
                  return;
                }
                final replaceMoney = withdrawMoneyCtrl.text
                    .replaceAll(".", "")
                    .replaceAll("đ", "");
                final withdraw = int.tryParse(replaceMoney) ?? 0;

                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => PinCodeButtomSheet(
                    (value) => bloc.requestWithdraw(withdraw).then(
                      (value) {
                        return navigator.pop();
                      },
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _bodyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocConsumer<DepositWithdrawCubit, DepositWithdrawState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CubitStatus.loading) {
              showLoading();
            } else {
              EasyLoading.dismiss();
            }
            if (state.status == CubitStatus.sendSuccess && state.index == 0) {
              final detail = state.deposit;
              _showQRDialog(context, detail);
            } else if (state.status == CubitStatus.sendSuccess &&
                state.index == 1) {
              navigator.pop();
              DialogUtils.showSuccessDialog(
                hasButtonBack: false,
                context,
                title: "Đã gửi lệnh rút tiền!",
                content:
                    "Lệnh rút tiền của bạn đã được gửi tới ASBC HUB thành công. Vui lòng chờ quản trị sàn phê duyệt giao dịch!",
                accept: () {
                  navigator.replaceAll([const RootRoute()]);
                },
              );
            }
          },
          builder: (context, state) {
            return TabBar(
              onTap: (value) => bloc.setTab(value),
              padding: EdgeInsets.zero,
              controller: _tabController,
              tabs: const [
                Tab(text: "Nạp tiền"),
                Tab(text: "Rút tiền"),
              ],
              indicatorColor: AppColors.main,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: s16w500.copyWith(color: AppColors.main),
            );
          },
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _depositView(),
              _withdrawView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _depositView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: key1,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseContainer(
                  padding: 16.pading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Số tiền cần nạp",
                        style: s16w400,
                      ),
                      8.height,
                      ValidateTextField(
                        controller: inputMoneyCtrl,
                        initialValue: "",
                        margin: EdgeInsets.zero,
                        backgroundColor: AppColors.white,
                        hintText: 'Nhập số tiền cần nạp',
                        hintStyle: s14w400.copyWith(
                          color: AppColors.grey_1,
                        ),
                        textInputType: TextInputType.phone,
                        maxLines: 1,
                        onChanged: (value) {
                          _onTextChanged(value, inputMoneyCtrl);
                        },
                        validator: (value) {
                          if (value.nullOrEmpty) {
                            return "Bạn chưa nhập số tiền";
                          }
                          return null;
                        },
                      ),
                      16.height,
                      Container(
                        width: double.infinity,
                        child: BlocBuilder<DepositWithdrawCubit,
                            DepositWithdrawState>(
                          builder: (context, state) {
                            final detail = state.deposit;
                            if (detail == null) {
                              return const SizedBox.shrink();
                            }
                            return ExtraButton(
                              color: AppColors.blue31,
                              borderColor: AppColors.blue31,
                              icon: const Icon(
                                Icons.qr_code,
                                color: AppColors.blue31,
                              ),
                              largeButton: true,
                              title: "Bấm để xem thông tin chuyển khoản",
                              onTap: () {
                                _showQRDialog(context, detail);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _withdrawView() {
    return BlocBuilder<WalletCubit, CubitState>(
      bloc: walletBloc..getWallets(),
      builder: (context, walletState) {
        final balance = walletBloc.walletsAwait
                .firstWhere((element) => element.type == 0)
                .balance ??
            0;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Form(
            key: key2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseContainer(
                    padding: 16.pading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rút tiền từ",
                          style: s16w400,
                        ),
                        BaseContainer(
                          padding: 8.pading,
                          borderColor: AppColors.purple_1,
                          color: AppColors.purple_2,
                          child: Row(
                            children: [
                              Assets.icons.icWalletSelect.svg(),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Ví Rút tiền", style: s14w500),
                                  Text(formatCurrency(balance), style: s14w500),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.height,
                        requiredTitle("Số tiền cần rút"),
                        8.height,
                        ValidateTextField(
                          controller: withdrawMoneyCtrl,
                          initialValue: "",
                          margin: EdgeInsets.zero,
                          backgroundColor: AppColors.white,
                          hintText: 'Nhập số tiền cần rút',
                          hintStyle: s14w400.copyWith(
                            color: AppColors.grey_1,
                          ),
                          textInputType: TextInputType.number,
                          maxLines: 1,
                          onChanged: (value) =>
                              _onTextChanged(value, withdrawMoneyCtrl),
                          validator: (value) {
                            final replaceMoney =
                                value?.replaceAll(".", "").replaceAll("đ", "");
                            final withdraw =
                                int.tryParse(replaceMoney ?? "") ?? 0;
                            if (value.nullOrEmpty) {
                              return "Bạn chưa nhập số tiền";
                            } else if (withdraw < 100000) {
                              return "Vui lòng nhập giá trị tối thiểu là 100.000đ";
                            } else if (withdraw > balance) {
                              return "Số tiền rút lớn hơn số dư trong Ví.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  BlocBuilder<DepositWithdrawCubit, DepositWithdrawState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state.listMyBank?.isEmpty == true) {
                        return const SizedBox.shrink();
                      }

                      return BaseContainer(
                        padding: 16.pading,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rút về tài khoản",
                                  style: s14w500,
                                ),
                                // Text(
                                //   "Xem tất cả",
                                //   style: s14w500.copyWith(color: AppColors.main),
                                // ),
                              ],
                            ),
                            16.height,
                            SizedBox(
                              height: 46,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final bank = state.listMyBank?[index];
                                  final isSelect =
                                      state.myBankSelect?.id == bank?.id;
                                  return GestureDetector(
                                    onTap: () => bloc.selectWithdrawBank(bank),
                                    child: BaseContainer(
                                      // width: context.width * 0.4,
                                      color: isSelect
                                          ? AppColors.purple_2
                                          : AppColors.white,
                                      borderColor:
                                          isSelect ? AppColors.purple_1 : null,
                                      padding: 4.pading,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CacheNetworkImageV2(
                                            width: 24,
                                            height: 24,
                                            url: bank?.bankData?.logo,
                                            fit: BoxFit.contain,
                                          ),
                                          8.width,
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (bank?.bankData?.shortName ??
                                                        "")
                                                    .toUpperCase(),
                                                style: s12w500,
                                              ),
                                              Text(
                                                bank?.accountNumber ?? "",
                                                style: s8w400,
                                              ),
                                            ],
                                          ),
                                          8.width,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => 8.width,
                                itemCount: state.listMyBank?.length ?? 0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<dynamic> _showQRDialog(
  BuildContext context,
  DepositQrCodeModel? detail,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        height: context.height * 0.8,
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(32),
          //   topRight: Radius.circular(32),
          // ),
          color: AppColors.white,
        ),
        child: BaseScaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        16.width,
                        const Text(
                          'Thông tin chuyển khoản',
                          style: s18w500,
                        ),
                        GestureDetector(
                          onTap: () => context.router.pop(),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    32.height,
                    const Text(
                      'Chuyển khoản với thông tin dưới đây để hoàn tất yêu cầu nạp tiền!',
                      style: s12w400,
                      textAlign: TextAlign.center,
                    ),
                    16.height,
                    // Center(
                    //   child: ImageNetWork(
                    //     path: detail?.qrCode ?? '',
                    //     height: 40,
                    //   ),
                    // ),
                    // 8.height,
                    Center(
                      child: Text(
                        detail?.bankName ?? '',
                        style: s16w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    15.height,
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        // padding: 16.pading,
                        decoration: BoxDecoration(
                          borderRadius: 18.radius,
                          border: Border.all(color: AppColors.main),
                        ),
                        child: ClipRRect(
                          borderRadius: 16.radius,
                          child: Image.network(
                            detail?.qrLink ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    15.height,
                    InkWell(
                      onTap: () => (detail?.bankAccount ?? '').copy,
                      child: TextAndText(
                        title: 'Số tài khoản:',
                        crossAxisAlignment: CrossAxisAlignment.center,
                        subtitle: detail?.bankAccount ?? '',
                        textAlign: TextAlign.left,
                        style: s16w700,
                        isExpanded: false,
                        icon: const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: AppColors.main,
                        ).padding(4.padingLeft),
                      ),
                    ),
                    8.height,
                    Text(
                      'Chủ tài khoản:',
                      style: s14w400.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                    InkWell(
                      onTap: () => detail?.userBankName.copy,
                      child: Row(
                        children: [
                          Text(
                            detail?.userBankName ?? '',
                            style: s14w700,
                          ).flexible(),
                          const Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: AppColors.main,
                          ).padding(4.padingLeft),
                        ],
                      ),
                    ),
                    8.height,
                    InkWell(
                      onTap: () => (detail?.amount ?? "").copy,
                      child: TextAndText(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        title: 'Số tiền:',
                        subtitle: formatCurrency(
                          int.tryParse(detail?.amount ?? "") ?? 0,
                        ),
                        textAlign: TextAlign.left,
                        style: s18w700.copyWith(
                          color: AppColors.main,
                        ),
                        isExpanded: false,
                        icon: const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: AppColors.main,
                        ).padding(4.padingLeft),
                      ),
                    ),
                    8.height,
                    Text(
                      'Nội dung chuyển khoản:',
                      style: s14w400.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                    InkWell(
                      // onTap: () =>
                      //     (bloc.cardOrder?.bankData?.addInfo ?? '').copy,
                      child: Row(
                        children: [
                          Text(
                            detail?.content ?? '',
                            style: s14w700,
                          ).flexible(),
                          const Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: AppColors.main,
                          ).padding(4.padingLeft),
                        ],
                      ),
                    ),
                  ],
                ).size(width: context.width),
                // context.padding.bottom.height,
              ],
            ).padding(
              16.pading,
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              ExtraButton(
                borderColor: AppColors.main,
                bgColor: AppColors.main.withOpacity(0.1),
                onTap: () async {
                  ImageUtils.saveImage(detail?.qrLink, context);
                  // final res = await getIt<BaseDio>()
                  //     .download(bloc.cardOrder?.bankData?.qr ?? "");
                  // print(res);
                  // if (res != null) {
                  //   Toast.showToast(
                  //     "Tải ảnh thành công $res",
                  //     context,
                  //   );
                  // }
                },
                largeButton: false,
                title: 'Lưu mã QR',
                icon: const Icon(
                  Icons.file_present_outlined,
                  color: AppColors.main,
                  size: 20,
                ),
                textStyle: s14w500.copyWith(
                  color: AppColors.main,
                ),
                radius: 99,
              ),
              8.width,
              MainButton(
                onTap: () {
                  context.router.pop();
                },
                largeButton: false,
                title: 'Quay lại',
                radius: 99,
              ).expanded(),
            ],
          ).padding(16.pading),
        ),
        // Stack(
        //   children: [
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: ),
        //   ],
        // ),
      ),
    ),
  );
}

class PinCodeButtomSheet extends StatefulWidget {
  const PinCodeButtomSheet(this.onDone);
  final Function(bool? vualue) onDone;

  @override
  State<PinCodeButtomSheet> createState() => _PinCodeButtomSheetState();
}

class _PinCodeButtomSheetState extends State<PinCodeButtomSheet> {
  @override
  void didUpdateWidget(covariant PinCodeButtomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final navigator = getIt.get<AppNavigator>();
  final bloc = getIt.get<DepositWithdrawCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepositWithdrawCubit, DepositWithdrawState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CubitStatus.loading) {
          showLoading();
        } else if (state.status == CubitStatus.success) {
          widget.onDone(true);
        }
        EasyLoading.dismiss();
      },
      bloc: bloc,
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.greyEA,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: BaseScaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            backgroundImage: false,
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.greyEA,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: Spacing.a16,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => navigator.pop(),
                            child: const Icon(Icons.close),
                          ),
                          const Text(
                            "Nhập PIN thanh toán",
                            style: s16w500,
                          ),
                          14.width,
                        ],
                      ),
                      12.height,
                      PinInputField(
                        onDone: bloc.verificationToken,
                        // validator: (p0) {
                        //   if (p0.nullOrEmpty) {
                        //     return "Mã token giao dịch có 6 chữ số";
                        //   }
                        //   if (p0.nullOrEmpty) {
                        //     return "Mã token giao dịch có 6 chữ số";
                        //   }
                        // },
                      ),
                      if (state.status == CubitStatus.error)
                        Text(
                          'Mã pin không đúng',
                          style: s14w400.copyWith(color: AppColors.red_1),
                        ),
                      12.height,
                      Text(
                        "Nhập mã PIN thanh toán để thực hiện giao dịch",
                        style: s14w400.copyWith(color: AppColors.grey79),
                      ),
                      12.height,
                      GestureDetector(
                        onTap: () =>
                            navigator.push(const ChangeTokenBankScreen()),
                        child: Text(
                          " Quên mã PIN? Đặt lại ngay",
                          style: s14w400.copyWith(color: AppColors.blue31),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
