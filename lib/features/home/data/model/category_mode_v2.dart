import 'package:BGP_Retail/features/home/data/model/product_model_v2.dart';

class CategoryModelV2 {
  int? id;
  String? title;
  String? code;
  String? createdAt;
  String? updateAt;
  String? image;
  List<ProductModelV2>? productData;

  CategoryModelV2({
    this.id,
    this.title,
    this.code,
    this.createdAt,
    this.updateAt,
    this.image,
    this.productData,
  });

  CategoryModelV2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    image = json['image'];
    productData = json['product_data'] is List
        ? (json['product_data'] as List)
            .map((e) => ProductModelV2.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['code'] = this.code;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['image'] = this.image;
    return data;
  }
}
