import 'package:auto_route/auto_route.dart';
import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/extension/spacing_extension.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:drmom/core/widgets/textfield/search_input_field.dart';
import 'package:drmom/features/health/data/bloc/health_cubit.dart';
import 'package:drmom/features/health/data/bloc/health_state.dart';
import 'package:drmom/features/health/data/models/health_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage>
    with AutomaticKeepAliveClientMixin {
  final _cubit = getIt.get<HealthCubit>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit.fetchHealthPosts();
    _searchController.addListener(() {
      _cubit.updateSearchKeyword(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HealthCubit, HealthState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state.status == CubitStatus.loading && state.posts.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brand_main),
              );
            }

            if (state.status == CubitStatus.error && state.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error_red,
                      size: 48,
                    ),
                    16.height,
                    Text(
                      state.message.isNotEmpty
                          ? state.message
                          : 'Đã có lỗi xảy ra',
                      style: AppTypography.p5,
                    ),
                    16.height,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand_main,
                      ),
                      onPressed: () => _cubit.fetchHealthPosts(force: true),
                      child: Text(
                        'Tải lại',
                        style: AppTypography.p7.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Client-side filtering logic based on category and search keyword
            final filteredPosts = state.posts.where((post) {
              final matchesCategory =
                  state.selectedCategory == 'Tất cả' ||
                  post.category == state.selectedCategory;
              final matchesSearch =
                  state.searchKeyword.isEmpty ||
                  (post.title?.toLowerCase().contains(
                        state.searchKeyword.toLowerCase(),
                      ) ??
                      false) ||
                  (post.description?.toLowerCase().contains(
                        state.searchKeyword.toLowerCase(),
                      ) ??
                      false);
              return matchesCategory && matchesSearch;
            }).toList();

            // Pinned/Featured post is the first pinned post, or if none, the first post
            final HealthPostModel? featuredPost = filteredPosts.isNotEmpty
                ? (filteredPosts.firstWhere(
                    (p) => p.isPinned == true,
                    orElse: () => filteredPosts.first,
                  ))
                : null;

            // Latest posts are the rest
            final latestPosts = filteredPosts.isNotEmpty
                ? filteredPosts.where((p) => p.id != featuredPost?.id).toList()
                : <HealthPostModel>[];

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SearchInputField(
                          controller: _searchController,
                          hintText: 'Tìm kiếm bạn bè, bài viết...',
                          color: const Color(0xFFF9F9F9),
                          borderColor: const Color(0xFFECEFF1),
                        ),
                      ),
                      16.height,
                      _buildCategoryFilters(state),
                      16.height,
                      if (filteredPosts.isEmpty) ...[
                        _buildEmptyState(),
                      ] else ...[
                        if (featuredPost != null) ...[
                          _buildFeaturedCard(featuredPost),
                          24.height,
                        ],
                        if (latestPosts.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Bài viết mới nhất',
                              style: AppTypography.h4.copyWith(
                                color: AppColors.text_primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          12.height,
                          ...latestPosts.map(
                            (post) => _buildLatestPostCard(post),
                          ),
                          16.height,
                          _buildLoadMoreButton(),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BaseContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            fit: BoxFit.contain,
          ),
          const Stack(
            children: [
              BaseContainer(
                padding: EdgeInsets.all(8),
                color: Color(0xFFF2F4F7),
                isCircle: true,
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.text_primary,
                  size: 24,
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: BaseContainer(
                  padding: EdgeInsets.all(4),
                  color: Color(0xFFF09000),
                  isCircle: true,
                  constraints: BoxConstraints(minWidth: 10, minHeight: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(HealthState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: state.categories.map((category) {
          final isSelected = state.selectedCategory == category.name;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BaseContainer(
              borderRadius: 100,
              borderColor: isSelected ? null : const Color(0xFFE4E7EC),
              color: isSelected ? AppColors.brand_main : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              inkWell: true,
              onTap: () => _cubit.changeCategory(category.name ?? ''),
              child: Text(
                category.name ?? '',
                style: AppTypography.p7.copyWith(
                  color: isSelected ? Colors.white : const Color(0xFF344054),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(HealthPostModel post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
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
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  post.imageUrl ?? '',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: const Color(0xFFEAECF0),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined, size: 40),
                    ),
                  ),
                ),
              ),
              // Dark gradient overlay on bottom of the image for text legibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating badges at top left
              Positioned(
                top: 16,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC67C4E).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'NỔI BẬT',
                            style: AppTypography.p11.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'MỚI NHẤT',
                        style: AppTypography.p11.copyWith(
                          color: const Color(0xFFC67C4E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Floating Category & Title overlay at bottom of the image
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        post.category ?? '',
                        style: AppTypography.p11.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    8.height,
                    Text(
                      post.title ?? '',
                      style: AppTypography.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=33',
                  ),
                ),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author ?? '',
                        style: AppTypography.p6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: Color(0xFF667085),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.readTime ?? '',
                            style: AppTypography.p11.copyWith(
                              color: const Color(0xFF667085),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: AppTypography.p11.copyWith(
                              color: const Color(0xFF667085),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            post.publishedAt ?? '',
                            style: AppTypography.p11.copyWith(
                              color: const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border_rounded,
                    size: 20,
                    color: Color(0xFF344054),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestPostCard(HealthPostModel post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    post.imageUrl ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: const Color(0xFFEAECF0),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          post.category ?? '',
                          style: AppTypography.p11.copyWith(
                            color: const Color(0xFFC67C4E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      6.height,
                      Text(
                        post.title ?? '',
                        style: AppTypography.p5.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_primary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.height,
                      Text(
                        post.description ?? '',
                        style: AppTypography.p7.copyWith(
                          color: AppColors.text_secondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  size: 16,
                  color: Color(0xFF98A2B3),
                ),
                4.width,
                Text(
                  '${post.likes ?? 0}',
                  style: AppTypography.p11.copyWith(
                    color: const Color(0xFF667085),
                  ),
                ),
                16.width,
                const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 16,
                  color: Color(0xFF98A2B3),
                ),
                4.width,
                Text(
                  post.views ?? '',
                  style: AppTypography.p11.copyWith(
                    color: const Color(0xFF667085),
                  ),
                ),
                16.width,
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Color(0xFF98A2B3),
                ),
                4.width,
                Text(
                  post.readTime ?? '',
                  style: AppTypography.p11.copyWith(
                    color: const Color(0xFF667085),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: BaseContainer(
        isDotted: true,
        borderColor: const Color(0xFFEAECF0),
        borderRadius: 16,
        color: Colors.white,
        inkWell: true,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tính năng đang được phát triển',
                style: AppTypography.p6.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.brand_main,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            'Xem thêm bài viết',
            style: AppTypography.p5.copyWith(
              color: const Color(0xFF344054),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF98A2B3),
              size: 64,
            ),
            12.height,
            Text(
              'Không tìm thấy bài viết nào',
              style: AppTypography.p3.copyWith(
                color: AppColors.text_primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            Text(
              'Hãy thử tìm kiếm với từ khóa khác hoặc chọn chuyên mục khác.',
              textAlign: TextAlign.center,
              style: AppTypography.p7.copyWith(color: AppColors.text_secondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
