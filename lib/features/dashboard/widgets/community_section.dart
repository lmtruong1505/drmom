import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/injection/injection.dart';
import 'package:drmom/core/utilities/enum.dart';
import 'package:drmom/features/dashboard/data/bloc/community_post_cubit.dart';
import 'package:drmom/features/dashboard/data/bloc/community_post_state.dart';
import 'package:drmom/features/dashboard/data/models/community_post_model.dart';
import 'package:drmom/features/dashboard/data/models/community_post_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunitySection extends StatefulWidget {
  const CommunitySection({super.key});

  @override
  State<CommunitySection> createState() => _CommunitySectionState();
}

class _CommunitySectionState extends State<CommunitySection>
    with AutomaticKeepAliveClientMixin {
  final _cubit = getIt.get<CommunityPostCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchCommunityPosts();
  }

  String _stripHtml(String htmlString) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regExp, '').replaceAll('&nbsp;', ' ').trim();
  }

  String _getTimeAgo(String? createdAt) {
    if (createdAt == null) return '';
    final parsedDate = DateTime.tryParse(createdAt);
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
    super.build(context);
    return BlocBuilder<CommunityPostCubit, CommunityPostState>(
      bloc: _cubit,
      builder: (context, state) {
        final List<CommunityPostModel> displayPosts =
            state.status == CubitStatus.success && state.posts.isNotEmpty
            ? state.posts
            : [
                CommunityPostModel(
                  id: 1,
                  content:
                      'Bé nhà mình 6 tháng rồi, định bắt đầu cho bé ăn dặm nhưng chưa biết nên bắt đầu từ đâu. Các mẹ chia sẻ kinh nghiệm giúp em với ạ! 🥺',
                  title: 'Mẹ nào có kinh nghiệm về việc cho bé ăn dặm không ạ?',
                  createdAt: DateTime.now()
                      .subtract(const Duration(hours: 2))
                      .toIso8601String(),
                  user: CommunityPostUserModel(
                    fullname: 'Nguyễn Thu Hà',
                    avatar: 'https://i.pravatar.cc/150?u=1',
                    role: PostRoleModel(label: 'MẸ MỚI', value: 'user'),
                  ),
                  totalInteract: 24,
                  commentCount: 48,
                ),
              ];

        final primaryPost = displayPosts.first;
        final authorName = primaryPost.user?.fullname ?? 'Thành viên';
        final userAvatar =
            primaryPost.user?.avatar ??
            'https://i.pravatar.cc/150?u=${primaryPost.id}';
        final userRole = primaryPost.user?.role?.label ?? 'Thành viên';
        final timeAndLoc = '${_getTimeAgo(primaryPost.createdAt)} • Việt Nam';

        final rawText = _stripHtml(primaryPost.content ?? '');
        String titleText = '';
        String contentText = '';
        if (primaryPost.title != null && primaryPost.title!.isNotEmpty) {
          titleText = primaryPost.title!;
          contentText = rawText;
        } else {
          final periodIndex = rawText.indexOf('.');
          if (periodIndex != -1 && periodIndex < 80) {
            titleText = rawText.substring(0, periodIndex).trim();
            contentText = rawText.substring(periodIndex + 1).trim();
          } else {
            if (rawText.length > 60) {
              titleText = '${rawText.substring(0, 60).trim()}...';
              contentText = rawText;
            } else {
              titleText = rawText.isNotEmpty ? rawText : 'Chia sẻ từ cộng đồng';
              contentText = '';
            }
          }
        }

        final likesCount = primaryPost.totalInteract ?? 0;
        final commentsCount = primaryPost.commentCount ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.brand_main,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cộng đồng',
                        style: AppTypography.p4.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_primary,
                        ),
                      ),
                      Text(
                        '12.5k thành viên',
                        style: AppTypography.p7.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Tham gia',
                        style: AppTypography.p6.copyWith(
                          color: AppColors.brand_main,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.brand_main,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border_subtle),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userAvatar),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                authorName,
                                style: AppTypography.p6.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.bg_secondary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  userRole.toUpperCase(),
                                  style: AppTypography.p8.copyWith(
                                    color: AppColors.brand_main,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            timeAndLoc,
                            style: AppTypography.p8.copyWith(
                              color: AppColors.text_secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (titleText.isNotEmpty)
                    Text(
                      titleText,
                      style: AppTypography.p5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (titleText.isNotEmpty && contentText.isNotEmpty)
                    const SizedBox(height: 12),
                  if (contentText.isNotEmpty)
                    Text(
                      contentText,
                      style: AppTypography.p6.copyWith(
                        color: AppColors.text_secondary,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg_secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite_outline, size: 16),
                            const SizedBox(width: 6),
                            Text('$likesCount', style: AppTypography.p7),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bg_secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 16),
                            const SizedBox(width: 6),
                            Text('$commentsCount', style: AppTypography.p7),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Trả lời',
                        style: AppTypography.p6.copyWith(
                          color: AppColors.brand_main,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 80,
                    height: 32,
                    child: Stack(
                      children: List.generate(3, (index) {
                        return Positioned(
                          left: index * 20.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?u=$index',
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Text(
                    'đang hoạt động',
                    style: AppTypography.p7.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard('2.4k+', 'Bài viết', Icons.menu_book),
                  const SizedBox(width: 12),
                  _buildStatCard('12.5k', 'Thành viên', Icons.people_outline),
                  const SizedBox(width: 12),
                  _buildStatCard('98%', 'Hài lòng', Icons.favorite_outline),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border_subtle),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.yellow_subtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.brand_main, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTypography.p4.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.p8.copyWith(color: AppColors.text_secondary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
