class HealthCareModel {
  int? id;
  String? name;
  String? code;
  String? address;
  String? phone;
  String? hotline;
  String? image;

  HealthCareModel(
      {this.id,
      this.name,
      this.code,
      this.address,
      this.phone,
      this.hotline,
      this.image});

  HealthCareModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    address = json['address'];
    phone = json['phone'];
    hotline = json['hotline'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['address'] = address;
    data['phone'] = phone;
    data['hotline'] = hotline;
    return data;
  }
}
