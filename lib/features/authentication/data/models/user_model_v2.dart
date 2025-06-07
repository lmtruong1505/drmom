import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';

class UserModelV2 {
  String? referralCode;
  String? phone;
  String? fullName;
  String? birthday;
  AddressData? address;
  int? gender;
  String? identified;
  String? dateProvided;
  String? placeProvided;
  String? imageFront;
  String? imageBack;
  String? email;
  String? avatar;

  UserModelV2({
    this.referralCode,
    this.phone,
    this.fullName,
    this.birthday,
    this.address,
    this.gender,
    this.identified,
    this.dateProvided,
    this.placeProvided,
    this.imageFront,
    this.imageBack,
    this.email,
    this.avatar,
  });

  UserModelV2.fromJson(Map<String, dynamic> json) {
    referralCode = json['referral_code'];
    phone = json['phone'];
    fullName = json['full_name'];
    birthday = json['birthday'];
    address =
        json['address'] != null ? AddressData.fromJson(json['address']) : null;
    gender = json['gender'];
    identified = json['identified'];
    dateProvided = json['date_provided'];
    placeProvided = json['place_provided'];
    imageFront = json['image_front'];
    imageBack = json['image_back'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referral_code'] = referralCode;
    data['phone'] = phone;
    data['full_name'] = fullName;
    data['birthday'] = birthday;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['gender'] = gender;
    data['identified'] = identified;
    data['date_provided'] = dateProvided;
    data['place_provided'] = placeProvided;
    data['image_front'] = imageFront;
    data['image_back'] = imageBack;
    data['email'] = email;
    data['avatar'] = avatar;

    return data;
  }
}

// class UserAddressV2 {
//   int? id;
//   String? title;
//   double? lat;
//   double? long;
//   Province? province;
//   District? district;
//   District? ward;

//   UserAddressV2({
//     this.id,
//     this.title,
//     this.lat,
//     this.long,
//     this.province,
//     this.district,
//     this.ward,
//   });

//   UserAddressV2.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     lat = json['lat'];
//     long = json['long'];
//     province =
//         json['province'] != null ? Province.fromJson(json['province']) : null;
//     district =
//         json['district'] != null ? District.fromJson(json['district']) : null;
//     ward = json['ward'] != null ? District.fromJson(json['ward']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['lat'] = lat;
//     data['long'] = long;
//     if (province != null) {
//       data['province'] = province!.toJson();
//     }
//     if (district != null) {
//       data['district'] = district!.toJson();
//     }
//     if (ward != null) {
//       data['ward'] = ward!.toJson();
//     }
//     return data;
//   }
// }

// class Province {
//   int? id;
//   String? title;
//   String? provinceCode;

//   Province({this.id, this.title, this.provinceCode});

//   Province.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     provinceCode = json['province_code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['province_code'] = provinceCode;
//     return data;
//   }
// }

// class District {
//   int? id;
//   String? title;
//   String? code;

//   District({this.id, this.title, this.code});

//   District.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     code = json['code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['code'] = code;
//     return data;
//   }
// }
