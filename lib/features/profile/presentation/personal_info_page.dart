import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import "package:bpg_retail/core/configs/app_style/init_app_style.dart";
import "package:bpg_retail/core/configs/app_style/init_app_style.dart";
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = getIt.get<AppCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Thông tin cá nhân",
          style: AppTypography.h3.copyWith(color: AppColors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
              child: BaseContainer(
                width: 80,
                height: 80,
                isCircle: true,
                color: AppColors.grey_e2,
                child: const Center(
                  child: Icon(Icons.person, size: 40, color: AppColors.grey_79),
                ),
              ),
            ),
            16.height,
            Text(
              "Người dùng",
              style: AppTypography.h4.copyWith(color: AppColors.black),
            ),
            24.height,

            // Info items
            _buildInfoTile(
              icon: Icons.person_outline,
              title: "Họ và tên",
              subtitle: "Người dùng",
            ),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              title: "Số điện thoại",
              subtitle: "---",
            ),
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              subtitle: "---",
            ),
            _buildInfoTile(
              icon: Icons.location_on_outlined,
              title: "Địa chỉ",
              subtitle: "---",
            ),

            32.height,

            // Logout button
            CommonButton(
              title: "Đăng xuất",
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text("Đăng xuất"),
                        content: const Text(
                          "Bạn có chắc chắn muốn đăng xuất không?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              "Hủy",
                              style: AppTypography.p5.copyWith(
                                color: AppColors.grey_79,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              appCubit.onForceLogout();
                            },
                            child: Text(
                              "Đăng xuất",
                              style: AppTypography.p5.copyWith(
                                color: AppColors.red_1,
                              ),
                            ),
                          ),
                        ],
                      ),
                );
              },
              buttonColor: AppColors.red_1,
              titleColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BaseContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 12,
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.grey_79),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.p6.copyWith(color: AppColors.grey_79),
                  ),
                  4.height,
                  Text(
                    subtitle,
                    style: AppTypography.p5.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
