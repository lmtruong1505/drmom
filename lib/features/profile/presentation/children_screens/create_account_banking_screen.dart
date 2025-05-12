import 'package:auto_route/auto_route.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/core/widgets/common/custom_switch.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom_v2.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/features/profile/data/models/bank_model.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/confirm_otp_bank_account.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/payment_detail_sreen.dart';

import '../../../../gen/assets.gen.dart';

@RoutePage()
class CreateAccountBankScreen extends StatefulWidget {
  const CreateAccountBankScreen({super.key, this.id});
  final int? id;

  @override
  State<CreateAccountBankScreen> createState() =>
      _CreateAccountBankScreenState();
}

class _CreateAccountBankScreenState extends State<CreateAccountBankScreen> {
  final bloc = getIt.get<DepositWithdrawCubit>();

  late TextEditingController bankNumberCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController searchCtrl;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bankNumberCtrl = TextEditingController();
    nameCtrl = TextEditingController();
    searchCtrl = TextEditingController();
    if (widget.id != null) {
      bloc.getBankDetail(widget.id!);
      bloc.setEdit(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepositWithdrawCubit, DepositWithdrawState>(
      bloc: bloc,
      listener: (context, state) {
        _listener(state);
      },
      child: _body(),
    );
  }

  Widget _body() {
    return BlocBuilder<DepositWithdrawCubit, DepositWithdrawState>(
      bloc: bloc,
      builder: (context, state) {
        final showBankSelect = state.bankSelect != null;
        return BaseScreen(
          padding: 16,
          title:
              bloc.isEdit ? "Thông tin tài khoản" : "Tạo tài khoản ngân hàng",
          body: BaseContainer(
            padding: 16.pading,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin ngân hàng",
                      style: s16w500,
                    ),
                    16.height,
                    Row(
                      children: [
                        const Text(
                          'Chọn ngân hàng',
                          style: AppTypography.p5,
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        Visibility(
                          visible: showBankSelect,
                          child: GestureDetector(
                            onTap: () => bloc.editBankSelect(),
                            child: const Text(
                              'Chỉnh sửa',
                              style: AppTypography.p5,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Visibility(
                      visible: !showBankSelect,
                      child: OverlayInputV2<BankModel>(
                        itemBuilder: (context, item, index) => bankItem(item),
                        onChanged: (item) {
                          bloc.selectBank(item);
                          searchCtrl.clear();
                        },
                        hintText: 'Nhập tên ngân hàng',
                        itemHeight: 72,
                        lazyLoad: (isMore) =>
                            bloc.getListBank(searchCtrl.text, isMore: isMore),
                        controller: searchCtrl,
                        borderRadius: 999,
                        suffix: const Icon(Icons.keyboard_arrow_down),
                        elevation: 1,
                      ).size(height: 50),
                    ),
                    Visibility(
                      visible: showBankSelect,
                      child: BaseContainer(
                        width: double.infinity,
                        borderColor: AppColors.greyAA,
                        padding: 16.pading,
                        borderRadius: 999,
                        child: Text(
                          state.bankSelect?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Số tài khoản',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: nameCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập số tài khoản',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Bạn chưa nhập số tài khoản';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chủ tài khoản',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    4.height,
                    ValidateTextField(
                      controller: bankNumberCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập tên chủ tài khoản',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Bạn chưa nhập tên chủ tài khoản';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    Container(
                      padding: Spacing.a16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 1.2,
                          color: AppColors.border_2,
                        ),
                      ),
                      child: BlocBuilder<DepositWithdrawCubit,
                          DepositWithdrawState>(
                        bloc: bloc,
                        builder: (context, state) {
                          return CustomSwitch(
                            label: "Đặt làm mặc định",
                            value: state.isDefault,
                            onChanged: (value) {
                              bloc.onSelectDefault(value);
                            },
                          );
                        },
                      ),
                    ),
                    16.height,
                    Row(
                      children: [
                        Assets.icons.icShieldCheck.svg(),
                        16.width,
                        Expanded(
                          child: Text(
                            "Mọi thông tin của bạn đều được bảo mật trên hệ thống của BGP_Retail",
                            style:
                                s14w400.copyWith(fontStyle: FontStyle.italic),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: bloc.isEdit,
                      child: Column(
                        children: [
                          16.height,
                          Container(
                            width: double.infinity,
                            child: ExtraButton(
                              onTap: () {
                                confirmDelete();
                              },
                              largeButton: true,
                              title: "Xoá tài khoản ngân hàng",
                              borderColor: AppColors.red,
                              color: AppColors.red,
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
          bottomNavigationBar: _bottomButton(),
        );
      },
    );
  }

  Widget bankItem(BankModel item) {
    return Container(
      padding: 16.pading,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CacheNetworkImageV2(
            url: item.logo,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
          8.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.shortName ?? '',
                  style: s14w500.copyWith(
                    color: AppColors.blackish,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.name ?? '',
                    style: s12w400.copyWith(
                      color: AppColors.blackish,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ExtraButton(
              largeButton: false,
              title: 'Huỷ bỏ',
              onTap: () => nav.pop(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ExtraButton(
              largeButton: false,
              title: bloc.isEdit ? "Lưu chỉnh sửa" : 'Tạo mới',
              color: AppColors.white,
              bgColor: AppColors.main,
              borderColor: AppColors.main,
              onTap: () {
                if (!formKey.currentState!.validate()) return;
                if (bloc.isEdit) {
                  bloc.updateBankAccount(nameCtrl.text, bankNumberCtrl.text);
                } else {
                  bloc.createBankAccount(
                    nameCtrl.text,
                    bankNumberCtrl.text,
                  );
                  context.dialog(
                    child: Dialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      backgroundColor: AppColors.white,
                      insetPadding: 16.pading,
                      child: ConfirmOtpBankAccount(
                        onTap: (value) {},
                      ),
                    ),
                  );
                  // bloc.createBankAccount(nameCtrl.text, bankNumberCtrl.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _listener(DepositWithdrawState state) {
    final status = state.status;
    if (status == CubitStatus.loading) {
      showLoading();
    } else if (status == CubitStatus.error) {
      showOverlayToast(title: state.message ?? "");
      EasyLoading.dismiss();
    } else if (status == CubitStatus.sendSuccess) {
      showOverlayToast(title: state.message ?? "");
      EasyLoading.dismiss();
      nav.pop(result: true);
    } else if (status == CubitStatus.update) {
      final detail = bloc.bankDetail;
      bankNumberCtrl.text = detail?.accountNumber ?? "";
      nameCtrl.text = detail?.accountName ?? "";
      bloc.selectBank(detail?.bankData);
      bloc.onSelectDefault(detail?.isDefault ?? false);
    }
  }

  void confirmDelete() {
    DialogUtils.showWarningDialog(
      context,
      content: "Bạnk có muốn xoá tài khoản ngân hàng",
      mainTap: () {
        bloc.deleteBankAccount();
      },
      isDouble: true,
    );
  }
}
