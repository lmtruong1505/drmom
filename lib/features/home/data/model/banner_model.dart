class BannerModel {
  int? id;
  String? linkUrl;
  int? type;
  bool? status;
  String? createdAt;
  String? updatedAt;
  TypeData? typeData;
  String? image;

  BannerModel({
    this.id,
    this.linkUrl,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.typeData,
    this.image,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    linkUrl = json['link_url'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeData =
        json['type_data'] != null ? TypeData.fromJson(json['type_data']) : null;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['link_url'] = linkUrl;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (typeData != null) {
      data['type_data'] = typeData!.toJson();
    }
    data['image'] = image;
    return data;
  }
}

class TypeData {
  int? id;
  String? title;
  String? size;

  TypeData({this.id, this.title, this.size});

  TypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['size'] = size;
    return data;
  }
}
