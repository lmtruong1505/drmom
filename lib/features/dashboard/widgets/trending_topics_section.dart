import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/bloc/hashtag_cubit.dart';
import 'package:drmom/features/dashboard/data/bloc/hashtag_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingTopicsSection extends StatefulWidget {
  const TrendingTopicsSection({super.key});

  @override
  State<TrendingTopicsSection> createState() => _TrendingTopicsSectionState();
}

class _TrendingTopicsSectionState extends State<TrendingTopicsSection> with AutomaticKeepAliveClientMixin {
  final _cubit = getIt.get<HashtagCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchHashtags();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HashtagCubit, HashtagState>(
      bloc: _cubit,
      builder: (context, state) {
        final List<String> displayTags = state.status == CubitStatus.success &&
                state.hashtags.isNotEmpty
            ? state.hashtags
                .map((e) => e.name != null
                    ? (e.name!.startsWith('#') ? e.name! : '#${e.name!}')
                    : '')
                .where((name) => name.isNotEmpty)
                .toList()
            : [
                '#Bú mẹ hoàn toàn',
                '#Tiêm chủng',
                '#Ăn dặm kiểu Nhật',
              ];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.brand_main.withOpacity(0.05),
            border: Border(
              top: BorderSide(
                color: AppColors.brand_main.withOpacity(0.15),
                width: 1,
              ),
              bottom: BorderSide(
                color: AppColors.brand_main.withOpacity(0.15),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.brand_main,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Chủ đề nổi bật hôm nay',
                      style: AppTypography.p5.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red_subtle,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Hot',
                        style: AppTypography.p8.copyWith(
                          color: AppColors.red70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: displayTags.map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.brand_main.withOpacity(0.1),
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.p6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

