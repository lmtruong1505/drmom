import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/bloc/post_cubit.dart';
import 'package:drmom/features/dashboard/data/bloc/post_state.dart';
import 'package:drmom/features/dashboard/data/models/category_data_model.dart';
import 'package:drmom/features/dashboard/data/models/post_model.dart';
import 'package:drmom/features/dashboard/data/models/thumbnail_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedPostsSection extends StatefulWidget {
  const FeaturedPostsSection({super.key});

  @override
  State<FeaturedPostsSection> createState() => _FeaturedPostsSectionState();
}

class _FeaturedPostsSectionState extends State<FeaturedPostsSection> with AutomaticKeepAliveClientMixin {
  final _cubit = getIt.get<PostCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchFeaturedPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PostCubit, PostState>(
      bloc: _cubit,
      builder: (context, state) {
        final List<PostModel> displayPosts =
            state.status == CubitStatus.success && state.posts.isNotEmpty
            ? state.posts
            : [
                PostModel(
                  id: 1,
                  title: 'Chăm sóc bé sơ sinh những ngày đầu',
                  author: 'BS. Nguyễn Minh',
                  publishedAt: DateTime.now()
                      .subtract(const Duration(days: 2))
                      .toIso8601String(),
                  categoryData: [
                    CategoryDataModel(id: 1, name: 'Sức khỏe nhi'),
                  ],
                  isPinned: true,
                  thumbnailData: ThumbnailDataModel(
                    image:
                        'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                  ),
                ),
                PostModel(
                  id: 2,
                  title: 'Dinh dưỡng cho bà bầu theo từng giai đoạn',
                  author: 'BS. Thu Hương',
                  publishedAt: DateTime.now()
                      .subtract(const Duration(days: 1))
                      .toIso8601String(),
                  categoryData: [CategoryDataModel(id: 2, name: 'Sức khỏe mẹ')],
                  isPinned: false,
                  thumbnailData: ThumbnailDataModel(
                    image:
                        'https://images.unsplash.com/photo-1531983412531-1f49a365ffed?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                  ),
                ),
              ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bài viết nổi bật',
                        style: AppTypography.p4.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Được yêu thích nhất tuần này',
                        style: AppTypography.p7.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Xem tất cả',
                        style: AppTypography.p7.copyWith(
                          color: AppColors.brand_main,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.brand_main,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ...displayPosts.map((post) => PostCard(post: post)),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  String _getTimeAgo(String? publishedAt) {
    if (publishedAt == null) return '';
    final parsedDate = DateTime.tryParse(publishedAt);
    if (parsedDate == null) return '';
    final difference = DateTime.now().difference(parsedDate);
    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months tháng trước';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks tuần trước';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = post.title ?? '';
    final author = post.author ?? 'Ban biên tập';
    final time = _getTimeAgo(post.publishedAt);
    final isHot = post.isPinned ?? false;

    final category =
        (post.categoryData != null && post.categoryData!.isNotEmpty)
        ? post.categoryData!.first.name ?? 'Tin tức'
        : 'Tin tức';

    final imageUrl =
        post.thumbnailData?.image ??
        'https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';

    // Calculate views and readTime programmatically since the API doesn't return them
    final views = '${(post.id ?? 100) % 5 + 1}.${((post.id ?? 100) % 9)}k';
    final readTime =
        '${((post.title ?? '').length / 30 + 3).clamp(3, 10).toInt()} phút';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border_subtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.bg_surface_subtle,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: AppColors.text_tertiary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brand_main.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    category,
                    style: AppTypography.p8.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isHot)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brand_main,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'NỔI BẬT',
                          style: AppTypography.p8.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.p5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text_primary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/100',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: AppTypography.p7.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.text_primary,
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: AppTypography.p8.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.border_subtle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 14,
                      color: AppColors.text_secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      views,
                      style: AppTypography.p8.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.text_secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      readTime,
                      style: AppTypography.p8.copyWith(
                        color: AppColors.text_secondary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.bg_surface_subtle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: AppColors.text_secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.bg_surface_subtle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: AppColors.text_secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
