import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:BGP_Retail/core/core.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

class HeaderHomeCategory extends StatefulWidget {
  const HeaderHomeCategory({super.key});

  @override
  State<HeaderHomeCategory> createState() => _HeaderHomeCategoryState();
}

class _HeaderHomeCategoryState extends State<HeaderHomeCategory> {
  final listCategory = [
    CategoryData(icon: Assets.icons.icHistory.svg(), title: ' Lịch sử khám'),
    CategoryData(icon: Assets.icons.icThuoc.svg(), title: 'Đơn thuốc'),
    CategoryData(icon: Assets.icons.icDoctor.svg(), title: 'Gọi Bác sĩ'),
    CategoryData(
        icon: Assets.icons.icLichkhamdinhki.svg(), title: 'Lịch khám định kỳ'),
    CategoryData(icon: Assets.icons.icLichsu.svg(), title: 'Đặt lịch'),
    CategoryData(icon: Assets.icons.icXetnghiem.svg(), title: 'Xét nghiệm'),
    CategoryData(
      icon: Assets.icons.icHososuckhoe.svg(),
      title: 'Hồ sơ sức khỏe',
    ),
  ];
  final preferences = getIt.get<Preferences>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: Stack(
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
            top: MediaQuery.of(context).viewPadding.top + 32,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào',
                      style: s12w400.copyWith(color: AppColors.white),
                    ),
                    Text(
                      preferences.getUserDataV3.fullName ?? '',
                      style: s20w700.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
                const Spacer(),
                CacheAvatarImage(
                  borderRadius: 999,
                  url: preferences.getUserDataV3.avatar,
                  width: 48,
                  height: 48,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                BaseContainer(
                  borderRadius: 16,
                  padding: 16.pading,
                  height: 194,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 72,
                    ),
                    itemBuilder: (context, index) {
                      final item = listCategory[index];
                      return _categoryItem(item);
                    },
                    itemCount: listCategory.length,
                  ),
                ),
              ],
            ).padding(16.padingHor),
          ),
        ],
      ),
    );
  }

  SizedBox _categoryItem(CategoryData item) {
    return SizedBox(
      height: 74,
      child: Column(
        children: [
          BaseContainer(
            width: 38,
            height: 38,
            color: AppColors.main,
            child: Center(child: item.icon),
          ),
          4.height,
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: s12w500.copyWith(
              fontSize: 10,
              color: AppColors.main,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryData {
  final SvgPicture icon;
  final String title;

  CategoryData({
    required this.icon,
    required this.title,
  });
}
