import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:flutter/material.dart';

class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: const Icon(Icons.groups, color: Colors.white, size: 24),
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
                color: Colors.black.withOpacity(0.04),
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
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=1',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nguyễn Thu Hà',
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
                              'MẸ MỚI',
                              style: AppTypography.p8.copyWith(
                                color: AppColors.brand_main,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '2 giờ trước • Hà Nội',
                        style: AppTypography.p8.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Mẹ nào có kinh nghiệm về việc cho bé ăn dặm không ạ?',
                style: AppTypography.p5.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Bé nhà mình 6 tháng rồi, định bắt đầu cho bé ăn dặm nhưng chưa biết nên bắt đầu từ đâu. Các mẹ chia sẻ kinh nghiệm giúp em với ạ! 🥺',
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
                        Text('24', style: AppTypography.p7),
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
                        Text('48', style: AppTypography.p7),
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
}
