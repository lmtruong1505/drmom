class DoctorModel {
  int? id;
  String? code;
  String? phoneNumber;
  String? fullName;
  String? avatar;
  List<Departments>? departments;

  DoctorModel(
      {this.id, this.code, this.phoneNumber, this.fullName, this.departments});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    fullName = json['full_name'];
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Departments {
  int? id;
  String? name;

  Departments({this.id, this.name});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
