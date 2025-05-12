import 'package:auto_route/auto_route.dart';
import 'package:BGP_Retail/app/data/bloc/app_cubit.dart';
import 'package:BGP_Retail/core/core.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/features/authentication/data/bloc/authentication_cubit.dart';
import 'package:flutter/widgets.dart';

@RoutePage()
class ProfileV2Screen extends StatefulWidget {
  const ProfileV2Screen({super.key});

  @override
  State<ProfileV2Screen> createState() => _ProfileV2ScreenState();
}

class _ProfileV2ScreenState extends State<ProfileV2Screen> {
  final user = getIt<Preferences>().getUserDataV3;
  final authCubit = getIt<AuthenticationCubit>();
  final appCubit = getIt<AppCubit>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 354,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            gradient: LinearGradient(
              colors: [Color(0xFF80BF9F), Color(0xFF007F3E)],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 70 + MediaQuery.of(context).viewPadding.top,
          child: BaseContainer(
            padding: 16.pading,
            borderRadius: 16,
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CacheAvatarImage(
                  borderRadius: 999,
                  url: user.avatar,
                ),
                8.height,
                Text(
                  user.fullName ?? '',
                  style: s18w700,
                ),
                4.height,
                Text(
                  '${user.gender?.label ?? 'Chưa có thông tin'} - ${user.dateOfBirth ?? 'Chưa có thông tin'}',
                  style: s14w700.copyWith(color: AppColors.grey80),
                ),
                16.height,
                BaseContainer(
                  width: double.infinity,
                  padding: 6.padingVer + 12.padingHor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã thẻ BHYT',
                        style: s12w400.copyWith(color: AppColors.grey80),
                      ),
                      Text(
                        user.citizenIdentity?.identityNumber ??
                            'Chưa có thông tin',
                        style: s14w500,
                      ),
                    ],
                  ),
                ),
                16.height,
                Row(
                  children: [
                    _columnInfor('Ngày tháng năm sinh', user.dateOfBirth)
                        .expanded(),
                    _columnInfor('Giới tính', user.gender?.label).expanded(),
                  ],
                ),
                16.height,
                Row(
                  children: [
                    _columnInfor(
                      'Căn cước công dân',
                      user.citizenIdentity?.identityNumber,
                    ).expanded(),
                    _columnInfor('Số điện thoại', user.phoneNumber).expanded(),
                  ],
                ),
                16.height,
                _columnInfor('Địa chỉ', user.citizenIdentity?.currentAddress),
                16.height,
                SizedBox(
                  width: double.infinity,
                  child: ExtraButton(
                    onTap: () {
                      authCubit.logOut();
                    },
                    title: 'Đăng xuất',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _columnInfor(String? title, String? desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: s12w400.copyWith(color: AppColors.grey80),
        ),
        Text(
          desc ?? 'Chưa có thông tin',
          style: s14w500,
        ),
      ],
    );
  }
}
