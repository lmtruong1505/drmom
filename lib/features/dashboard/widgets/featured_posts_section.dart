import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:flutter/material.dart';

class FeaturedPostsSection extends StatelessWidget {
  const FeaturedPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        const PostCard(
          title: 'Chăm sóc bé sơ sinh những ngày đầu',
          author: 'BS. Nguyễn Minh',
          time: '2 ngày trước',
          views: '2.4k',
          readTime: '5 phút',
          category: 'Sức khỏe nhi',
          isHot: true,
          imageUrl:
              'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ),
        const PostCard(
          title: 'Dinh dưỡng cho bà bầu theo từng giai đoạn',
          author: 'BS. Thu Hương',
          time: '1 ngày trước',
          views: '1.8k',
          readTime: '7 phút',
          category: 'Sức khỏe mẹ',
          isHot: false,
          imageUrl:
              'https://images.unsplash.com/photo-1531983412531-1f49a365ffed?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String time;
  final String views;
  final String readTime;
  final String category;
  final bool isHot;
  final String imageUrl;

  const PostCard({
    super.key,
    required this.title,
    required this.author,
    required this.time,
    required this.views,
    required this.readTime,
    required this.category,
    required this.isHot,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.brand_main.withOpacity(0.8),
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
                    Icon(
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
                    Icon(
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
                      decoration: BoxDecoration(
                        color: AppColors.bg_surface_subtle,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: AppColors.text_secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.bg_surface_subtle,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
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
