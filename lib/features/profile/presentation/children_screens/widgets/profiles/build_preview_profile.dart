import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/avatar_widget.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/identity_card_widget.dart';
import 'package:bpg_retail/core/widgets/row_item.dart';
import 'package:bpg_retail/core/widgets/toast/overlay_custom.dart';
import 'package:bpg_retail/core/widgets/toast/toast.dart';
import 'package:bpg_retail/core/widgets/toast/toast_position.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/features/profile/data/bloc/user_profile_cubit.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

String mapProfileTitle(String field) {
  switch (field) {
    case "date_of_birth":
      return "Ngày sinh";
    case "sex":
      return "Giới tính";
    default:
      return "";
  }
}

class UserProfileView extends StatelessWidget {
  UserProfileView({
    super.key,
    required this.bloc,
  });
  final UserProfileCubit bloc;
  final navigator = getIt.get<AppNavigator>();
  final preferences = getIt.get<Preferences>();
  final appCubit = getIt.get<AppCubit>();

  @override
  Widget build(BuildContext context) {
    final user = bloc.userData;
    return BlocListener<UserProfileCubit, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        _buildListner(state);
      },
      child: BaseScreen(
        padding: 16,
        title: "Thông tin cá nhân",
        onTap: () {
          print('navigator.pop(result: bloc.isUpdate)${bloc.isUpdate}');
          navigator.pop(result: bloc.isUpdate);
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BaseContainer(
            padding: 16.pading,
            child: Column(
              children: [
                Column(
                  children: [
                    AvatarWidget(url: user.avatar ?? '', size: 80)
                        .padding(16.padingBottom),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên",
                          style: AppTypography.p5
                              .copyWith(color: AppColors.grey_1),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          user.fullName ?? '_',
                          style: AppTypography.p5,
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại",
                          style: AppTypography.p5
                              .copyWith(color: AppColors.grey_1),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          user.phone ?? '_',
                          style: AppTypography.p5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                        visible: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email",
                                  style: AppTypography.p5
                                      .copyWith(color: AppColors.grey_1),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  user.email ?? '_',
                                  style: AppTypography.p5,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mã giới thiệu",
                          style: AppTypography.p5
                              .copyWith(color: AppColors.grey_1),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            // bloc.currentUser.accountCode.copy;
                            // copyToClipboard(bloc.currentUser.accountCode ?? '');
                            // Toast.showToast("Đã copy", context,
                            //     toastPosition: ToastPosition.CENTER);
                          },
                          child: Row(
                            children: [
                              // Text(
                              //   (bloc.currentUser.accountCode ?? ''),
                              //   style: AppTypography.p5,
                              // ),
                              8.width,
                              const Icon(
                                Icons.copy,
                                size: 14,
                                color: AppColors.bg_3,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Ngày sinh",
                      subtitle: user.birthday.toDateTimeFormat,
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Giới tính",
                      subtitle: convertGender(user.gender ?? 0),
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Địa chỉ",
                      subtitle: user.address?.addressFull ?? "",
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Số CCCD",
                      subtitle: user.identified ?? "",
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Ngày cấp",
                      subtitle: user.dateProvided.toDateTimeFormat,
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    BaseRowItem(
                      title: "Nơi cấp",
                      subtitle: user.placeProvided ?? "",
                      titleStyle: s14w500.copyWith(color: AppColors.grey_1),
                      subStyle: AppTypography.p5,
                    ),
                    16.height,
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Mặt trước",
                            style: s14w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Mặt sau",
                            style: s14w500,
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Row(
                      children: [
                        Expanded(
                          child: IdentityCardWidgetV2(
                            url: user.imageFront,
                            type: ImageIdentityTypeEnum.front,
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: IdentityCardWidgetV2(
                            url: user.imageBack,
                            type: ImageIdentityTypeEnum.back,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ExtraButton(
                    bgColor: AppColors.red_2,
                    largeButton: false,
                    title: 'Vô hiệu hóa tài khoản',
                    onTap: bloc.showConfirmDisableAccount,
                    color: AppColors.red_1,
                    borderColor: AppColors.red_1,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ExtraButton(
            largeButton: false,
            title: 'Chỉnh sửa thông tin',
            color: AppColors.white,
            bgColor: AppColors.main,
            borderColor: AppColors.main,
            onTap: () => bloc.onChangeEdit(true),
          ),
        ),
      ),
    );
  }

  void _buildListner(CubitState state) async {
    if (state.status == CubitStatus.success) {
      navigator.showSuccessDialog(
        title: 'Thông báo',
        mainTitle: 'Xác nhận',
        extraTitle: 'Hủy',
        content: 'Bạn xác nhận vô hiệu hóa tài khoản này',
        hasButtonBack: true,
        icon: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Assets.icons.icWarning.svg(),
        ),
        accept: () async {
          navigator.back();
          bloc.confirmDeactive();
        },
        extraAccept: () => navigator.back(),
      );
    } else if (state.status == CubitStatus.sendSuccess) {
      navigator.showSuccessSnackBar(
        'Vô hiệu hóa tài khoản thành công',
        duration: const Duration(seconds: 3),
      );
      appCubit.onForceLogout(isMessage: false);
    } else if (state.status == CubitStatus.sendFaild) {
      navigator.showErrorSnackBar(
        "Đã có lỗi xảy ra",
        duration: const Duration(seconds: 2),
      );
    } else {
      EasyLoading.dismiss();
    }
  }
}
