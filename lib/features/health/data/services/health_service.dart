import 'package:drmom/core/configs/dio_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HealthService {
  final BaseDio _baseDio;

  HealthService(this._baseDio);

  Future<dynamic> getHealthPosts() async {
    // For now, return mock data matching the exact schema for future API integration
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network lag
    return {
      "status": 200,
      "success": true,
      "message": "Thành công",
      "data": [
        {
          "id": 1,
          "title": "Bí quyết nuôi con khỏe mạnh từ chuyên gia hàng đầu",
          "description": "Chia sẻ kinh nghiệm nuôi dạy trẻ sơ sinh phát triển toàn diện cả thể chất lẫn tinh thần.",
          "content": "",
          "author": "BS. Nguyễn Thị E",
          "category": "Sức khỏe mẹ và bé",
          "published_at": "Hôm nay",
          "read_time": "10 phút đọc",
          "views": "3.5k",
          "likes": 256,
          "is_pinned": true,
          "is_newest": true,
          "image_url": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80"
        },
        {
          "id": 2,
          "title": "10 dấu hiệu bé phát triển tốt trong 6 tháng đầu",
          "description": "Nhận biết những tín hiệu tích cực cho thấy bé...",
          "content": "",
          "author": "BS. Nguyễn Minh",
          "category": "Sức khỏe nhi",
          "published_at": "Hôm qua",
          "read_time": "5 phút",
          "views": "2.4k",
          "likes": 142,
          "is_pinned": false,
          "is_newest": true,
          "image_url": "https://images.unsplash.com/photo-1555252333-9f8e92e65df9?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"
        },
        {
          "id": 3,
          "title": "Chế độ dinh dưỡng cho mẹ bầu 3 tháng đầu",
          "description": "Gợi ý thực đơn và dưỡng chất cần thiết giúp...",
          "content": "",
          "author": "BS. Thu Hương",
          "category": "Sức khỏe mẹ",
          "published_at": "2 ngày trước",
          "read_time": "5 phút",
          "views": "2.4k",
          "likes": 142,
          "is_pinned": false,
          "is_newest": false,
          "image_url": "https://images.unsplash.com/photo-1531983412531-1f49a365ffed?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80"
        },
        {
          "id": 4,
          "title": "Cách phòng ngừa cảm cúm cho trẻ em mùa đông",
          "description": "Những biện pháp đơn giản giúp bảo vệ bé...",
          "content": "",
          "author": "BS. Hoàng Nam",
          "category": "Sức khỏe gia đình",
          "published_at": "3 ngày trước",
          "read_time": "5 phút",
          "views": "2.4k",
          "likes": 142,
          "is_pinned": false,
          "is_newest": false,
          "image_url": "https://images.unsplash.com/photo-1519689680058-324335c77eba?auto=format&fit=crop&w=800&q=80"
        },
        {
          "id": 5,
          "title": "Mẹ sau sinh cần bổ sung những dưỡng chất gì?",
          "description": "Danh sách dưỡng chất quan trọng giúp mẹ...",
          "content": "",
          "author": "BS. Khánh Vy",
          "category": "Mẹ và bé",
          "published_at": "5 ngày trước",
          "read_time": "5 phút",
          "views": "2.4k",
          "likes": 142,
          "is_pinned": false,
          "is_newest": false,
          "image_url": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=800&q=80"
        }
      ]
    };
  }

  Future<dynamic> getNewsCategories() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network lag
    return {
      "status": 200,
      "success": true,
      "message": "Thành công",
      "data": [
        {
          "id": 43,
          "name": "Mẹ và bé",
          "description": "Chuyên mục mẹ và bé",
          "created_by": 84,
          "updated_by": 84,
          "modified_at": "2026-02-10T23:20:08.718823+07:00",
          "created_at": "2026-02-10T19:27:17.071163+07:00",
          "parent": null,
          "children_data": [
            {
              "id": 48,
              "name": "Chăm bé sơ sinh"
            },
            {
              "id": 47,
              "name": "Cách chăm bé 3 tháng tuổi"
            }
          ]
        },
        {
          "id": 33,
          "name": "Sức khỏe gia đình",
          "description": "Cập nhật kiến thức, kinh nghiệm và trải nghiệm về chăm sóc sức khỏe gia đình từ A-Z.",
          "created_by": 84,
          "updated_by": 84,
          "modified_at": "2026-02-09T17:28:29.165820+07:00",
          "created_at": "2026-01-19T16:03:10.959226+07:00",
          "parent": null,
          "children_data": [
            {
              "id": 53,
              "name": "Chế độ ăn uống"
            },
            {
              "id": 49,
              "name": "Gia đình là số 1"
            },
            {
              "id": 42,
              "name": "aaaaabbb"
            }
          ]
        },
        {
          "id": 27,
          "name": "Sức khỏe Nhi",
          "description": "Tất cả các kiến thức và kinh nghiệm chăm sóc trẻ từ 0 - 15 tuổi",
          "created_by": 19,
          "updated_by": 84,
          "modified_at": "2026-01-19T16:01:59.552733+07:00",
          "created_at": "2026-01-08T14:36:45.055795+07:00",
          "parent": null,
          "children_data": null
        },
        {
          "id": 26,
          "name": "Sức khỏe Mẹ",
          "description": "Cập nhật kiến thức và kinh nghiệm chăm sóc sức khỏe của phụ nữ, mẹ bầu, mẹ sau sinh.",
          "created_by": 13,
          "updated_by": 84,
          "modified_at": "2026-01-19T16:02:38.705287+07:00",
          "created_at": "2026-01-06T10:26:27.722490+07:00",
          "parent": null,
          "children_data": [
            {
              "id": 50,
              "name": "Sức khỏe của mẹ sau sinh"
            }
          ]
        }
      ]
    };
  }
}
