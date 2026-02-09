import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/preferences/preferences.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/cache_image_network_widget.dart';
import 'package:bpg_retail/features/card/data/cubits/card_bloc.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_state.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../wallet/data/cubits/wallet_cubit.dart';
import '../../../data/bloc/profile_cubit.dart';

class ProfileInfoTab extends StatefulWidget {
  final ProfileCubit bloc;
  const ProfileInfoTab({
    super.key,
    required this.bloc,
  });

  @override
  State<ProfileInfoTab> createState() => _ProfileInfoTabState();
}

class _ProfileInfoTabState extends State<ProfileInfoTab> {
  final nav = getIt.get<AppNavigator>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: widget.bloc..checkOpenShop(),
      builder: (context, state) {
        print('BlocBuilder====ProfileCubit');
        return SingleChildScrollView(
          padding: 16.padingHor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cardInfo(),
              16.height,
              _registerInfor(state),
              16.height,
              _buildSetting(),
              16.height,
              _buildInfor(state),
              16.height,
              ExtraButton(
                onTap: () => widget.bloc.appCubit.onForceLogout(),
                color: AppColors.red_1,
                bgColor: AppColors.red_2,
                borderColor: AppColors.red_1,
                radius: 30,
                largeButton: true,
                title: "Đăng xuất",
              ),
              16.height,
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thiết lập",
          style: s18w700,
        ),
        8.height,
        BaseContainer(
          borderRadius: 16,
          padding: 16.pading,
          child: Column(
            children: [
              _profileInfor(
                icon: Assets.icons.icMoney.svg(
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                ),
                titile: "Tài khoản ngân hàng",
                onTap: () {
                  nav.push(const AccountBankScreen());
                },
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icWalletSvg.svg(
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                titile: "Quản lý ví của tôi",
                onTap: () {
                  nav.push(const WalletRoute());
                },
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icWalletSvg.svg(
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                titile: "Quản lý thẻ của tôi",
                onTap: () {
                  nav.push(const MyCardRoute());
                },
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icMap.svg(),
                titile: "Địa chỉ nhận hàng",
                onTap: () {
                  nav.push(const AddressManagerRoute());
                },
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icShieldCheck2.svg(),
                titile: "Mã PIN thanh toán",
                onTap: () {
                  nav.push(const ChangeTokenBankScreen());
                },
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icPerson.svg(),
                titile: "Thông tin cá nhân",
                onTap: () async {
                  // final result = await nav.push(ProfileInfoRoute());
                  // if (result == true) {
                  //   widget.bloc.onRefesh();
                  // }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfor(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thông tin",
          style: s18w700,
        ),
        8.height,
        BaseContainer(
          borderRadius: 16,
          padding: 16.pading,
          child: Column(
            children: [
              // _profileInfor(
              //   icon: Assets.icons.icShop.svg(
              //     colorFilter: const ColorFilter.mode(
              //       AppColors.black,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              //   titile: "Gian hàng",
              //   onTap: () {
              //     nav.push(const BoothScreen());
              //   },
              // ),
              // 32.height,
              _profileInfor(
                icon: Assets.icons.icPeopleGroup.svg(),
                titile: "Đội nhóm của tôi",
                onTap: () {},
              ),
              32.height,
              _profileInfor(
                icon: const Icon(
                  Icons.history,
                  size: 20,
                ),
                titile: "Lịch sử giao dịch",
                onTap: () => nav.push(const PaymentHistoryScreen()),
              ),
              Visibility(
                visible: state.company != null && !state.isLoading,
                child: Column(
                  children: [
                    32.height,
                    _profileInfor(
                      icon: Assets.icons.icShop.svg(
                        colorFilter: const ColorFilter.mode(
                          AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      titile: "Thông tin shop",
                      onTap: () => nav.push(ShopRoute(data: state.company)),
                    ),
                  ],
                ),
              ),
              32.height,
              _profileInfor(
                icon: Assets.icons.icMoney2.svg(
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                titile: "Lệnh nạp/ rút tiền",
                onTap: () => nav.push(const DepositHistoryScreen()),
              ),
              32.height,
              _profileInfor(
                icon: const Icon(
                  Icons.vpn_key,
                  size: 20,
                ),
                titile: "Đổi mật khẩu",
                onTap: () => nav.push(const ChangePasswordRoute()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileInfor({
    required Widget icon,
    required String titile,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          icon,
          16.width,
          Text(
            titile,
            style: s14w500,
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _registerInfor(ProfileState state) {
    return Visibility(
      visible: state.company == null && !state.isLoading,
      child: GestureDetector(
        onTap: () async {
          final res = await context.pushRoute(const RegisterStoreRoute());
          if (res == true) {
            widget.bloc.checkOpenShop();
          }
        },
        child: BaseContainer(
          padding: 16.pading,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Đăng ký mở shop ngay",
                      style: s16w500,
                    ),
                    8.height,
                    const Text(
                      "Tăng doanh số bằng việc mở shop bán online trên ASBC HUB ngay",
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Assets.images.imageRegisterStore
                  .image(fit: BoxFit.cover, width: 80, height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardInfo() {
    final walletBloc = context.read<WalletCubit>()..setWallet(5);
    final cardBloc = context.read<CardBloc>();
    final user = widget.bloc.userData;
    return GestureDetector(
      onTap: () {
        context.pushRoute(const WalletRoute());
      },
      child: Stack(
        children: [
          Container(
            height: 220,
            padding: 24.pading,
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          user.fullName ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: s18w500.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        8.height,
                        Row(
                          children: [
                            Text(
                              user.phone ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: s14w400.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            4.width,
                            GestureDetector(
                              onTap: () => (user.phone ?? "").copy,
                              child: const Icon(
                                Icons.copy_outlined,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                            4.width,
                            GestureDetector(
                              onTap: showUserRefferallCode,
                              child: Text(
                                "Xem mã QR",
                                overflow: TextOverflow.ellipsis,
                                style: s14w400.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.white,
                                  decorationThickness: 1,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).expanded(),
                    8.width,
                    const AppAvatar(),
                  ],
                ),
                const Divider(
                  height: 20,
                  color: AppColors.white,
                ),
                BlocBuilder<WalletCubit, CubitState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PopupMenuButton(
                          offset: const Offset(1, 0),
                          color: Colors.white,
                          position: PopupMenuPosition.under,
                          constraints: const BoxConstraints(minWidth: 200),
                          onSelected: (value) {
                            walletBloc.setWallet(value);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                walletBloc.wallet.title,
                                style: s14w400.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: walletBloc.totalWallet.type,
                                child: Text(
                                  walletBloc.totalWallet.title,
                                  style: s14w500,
                                ),
                              ),
                              ...List.generate(
                                walletBloc.wallets.length,
                                (index) {
                                  return PopupMenuItem(
                                    value: walletBloc.wallets[index].type,
                                    child: Text(
                                      walletBloc.wallets[index].title,
                                      style: s14w500,
                                    ),
                                  );
                                },
                              ),
                              ...List.generate(
                                walletBloc.walletsAwait.length,
                                (index) {
                                  return PopupMenuItem(
                                    value: walletBloc.walletsAwait[index].type,
                                    child: Text(
                                      walletBloc.walletsAwait[index].title,
                                      style: s14w500,
                                    ),
                                  );
                                },
                              ),
                            ];
                          },
                        ).size(width: 200, height: 30),
                        4.height,
                        Text(
                          walletBloc.wallet.balance.toPrice(type: ' VNĐ'),
                          textAlign: TextAlign.center,
                          style: s20w700.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                20.height,
              ],
            ),
          ),
          DepositWithdrawTab(),
        ],
      ),
    );
  }

  void showUserRefferallCode() {
    context.dialog(
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: 16.pading,
                    // color: AppColors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        const Text(
                          "Mã QR của tôi",
                          style: s18w500,
                        ),
                        GestureDetector(
                          onTap: () => nav.pop(),
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  16.width,
                  Padding(
                    padding: 32.padingHor + 16.padingTop,
                    child: Row(
                      children: [
                        const AppAvatar(),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Text(
                            //   widget.bloc.currentUser.fullname ?? "",
                            //   overflow: TextOverflow.ellipsis,
                            //   style: s18w500,
                            // ),
                            // 8.height,
                            // Text(
                            //   widget.bloc.currentUser.phoneNumber ?? "",
                            //   overflow: TextOverflow.ellipsis,
                            //   style: s14w400,
                            // ),
                          ],
                        ).expanded(),
                      ],
                    ),
                  ),
                  24.height,
                  // Container(
                  //   width: 270,
                  //   height: 270,
                  //   child: BaseContainer(
                  //     borderRadius: 16,
                  //     padding: 24.pading,
                  //     child: QrImageView(
                  //       data: widget.bloc.currentUser.phoneNumber ?? "",
                  //     ),
                  //   ),
                  // ),
                  24.height,
                  ExtraButton(
                    padding: 8.padingVer + 64.padingHor,
                    largeButton: false,
                    onTap: () => nav.pop(),
                    title: "Đóng",
                  ),
                  24.height,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = getIt.get<Preferences>().getUserData.avatar;
    return CacheNetworkImageWidget(
      url: avatar,
      borderRadius: 999,
    );
  }
}

class DepositWithdrawTab extends StatelessWidget {
  DepositWithdrawTab({super.key});

  final nav = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        children: [
          // Nút Nạp Tiền
          Expanded(
            child: GestureDetector(
              onTap: () {
                nav.push(DepositWithdrawScreen(tab: 0));
              },
              child: ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  height: 42,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.icMoney.svg(width: 24, height: 24),
                      8.width,
                      Text(
                        'Nạp tiền',
                        style: s14w500.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          8.width,

          Expanded(
            child: GestureDetector(
              onTap: () {
                nav.push(DepositWithdrawScreen(tab: 1));
              },
              child: ClipPath(
                clipper: SlantedClipper(),
                child: Container(
                  height: 42,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.icMoney2.svg(width: 24, height: 24),
                      8.width,
                      Text(
                        'Rút tiền',
                        style: s14w500.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width * 0.9, 0); // Đường chéo bắt đầu 70% ngang
    path.lineTo(size.width, size.height); // Góc phải dưới
    path.lineTo(0, size.height); // Góc trái dưới
    path.close(); // Khép lại path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Bắt đầu từ góc trên bên trái
    path.lineTo(size.width, 0); // Đường chéo từ trái qua phải
    path.lineTo(size.width, size.height); // Xuống góc dưới bên phải
    path.lineTo(size.width * 0.10, size.height); // Góc dưới bên trái
    path.close(); // Đóng Path

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
