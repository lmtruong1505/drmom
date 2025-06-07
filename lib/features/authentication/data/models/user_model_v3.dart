// import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';

// class UserModelV3 {
//   int? id;
//   String? email;
//   String? code;
//   String? fullname;
//   Null? representative;
//   String? taxCode;
//   String? phoneNumber;

//   String? fullAddress;
//   bool? isSuperuser;
//   Null? state;
//   String? note;
//   List<WarehouseModel>? warehouses;
//   String? createdAt;
//   Null? datePeriod;
//   Null? avatar;
//   String? modifiedAt;
//   CreatedBy? createdBy;
//   CreatedBy? updatedBy;
//   String? statusLabel;
//   String? statusName;
//   int? status;
//   String? typeLabel;
//   String? typeName;
//   int? type;

//   UserModelV3(
//       {this.id,
//       this.email,
//       this.code,
//       this.fullname,
//       this.representative,
//       this.taxCode,
//       this.phoneNumber,
//       this.fullAddress,
//       this.isSuperuser,
//       this.state,
//       this.note,
//       this.warehouses,
//       this.createdAt,
//       this.datePeriod,
//       this.avatar,
//       this.modifiedAt,
//       this.createdBy,
//       this.updatedBy,
//       this.statusLabel,
//       this.statusName,
//       this.status,
//       this.typeLabel,
//       this.typeName,
//       this.type});

//   UserModelV3.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     email = json['email'];
//     code = json['code'];
//     fullname = json['fullname'];
//     representative = json['representative'];
//     taxCode = json['tax_code'];
//     phoneNumber = json['phone_number'];

//     fullAddress = json['full_address'];
//     isSuperuser = json['is_superuser'];
//     state = json['state'];
//     note = json['note'];
//     if (json['warehouses'] != null) {
//       warehouses = <WarehouseModel>[];
//       json['warehouses'].forEach((v) {
//         warehouses!.add(WarehouseModel.fromJson(v));
//       });
//     }
//     createdAt = json['created_at'];
//     datePeriod = json['date_period'];
//     avatar = json['avatar'];
//     modifiedAt = json['modified_at'];
//     createdBy = json['created_by'] != null
//         ? CreatedBy.fromJson(json['created_by'])
//         : null;
//     updatedBy = json['updated_by'] != null
//         ? CreatedBy.fromJson(json['updated_by'])
//         : null;
//     statusLabel = json['status_label'];
//     statusName = json['status_name'];
//     status = json['status'];
//     typeLabel = json['type_label'];
//     typeName = json['type_name'];
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['email'] = email;
//     data['code'] = code;
//     data['fullname'] = fullname;
//     data['representative'] = representative;
//     data['tax_code'] = taxCode;
//     data['phone_number'] = phoneNumber;

//     data['full_address'] = fullAddress;
//     data['is_superuser'] = isSuperuser;
//     data['state'] = state;
//     data['note'] = note;
//     if (warehouses != null) {
//       data['warehouses'] = warehouses!.map((v) => v.toJson()).toList();
//     }
//     data['created_at'] = createdAt;
//     data['date_period'] = datePeriod;
//     data['avatar'] = avatar;
//     data['modified_at'] = modifiedAt;
//     if (createdBy != null) {
//       data['created_by'] = createdBy!.toJson();
//     }
//     if (updatedBy != null) {
//       data['updated_by'] = updatedBy!.toJson();
//     }
//     data['status_label'] = statusLabel;
//     data['status_name'] = statusName;
//     data['status'] = status;
//     data['type_label'] = typeLabel;
//     data['type_name'] = typeName;
//     data['type'] = type;
//     return data;
//   }
// }

// class CreatedBy {
//   int? id;
//   String? fullname;

//   CreatedBy({this.id, this.fullname});

//   CreatedBy.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     fullname = json['fullname'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['fullname'] = fullname;
//     return data;
//   }
// }
import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model_v3.g.dart';

@JsonSerializable()
class UserModelV3 {
  UserModelV3({
    this.id,
    this.email,
    this.code,
    this.fullname,
    this.representative,
    this.taxCode,
    this.phoneNumber,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.fullAddress,
    this.isSuperuser,
    this.state,
    this.note,
    this.warehouses,
    this.createdAt,
    this.datePeriod,
    this.avatar,
    this.modifiedAt,
    this.createdBy,
    this.updatedBy,
    this.statusLabel,
    this.statusName,
    this.status,
    this.typeLabel,
    this.typeName,
    this.type,
  });

  final int? id;
  final String? email;
  final String? code;
  final String? fullname;
  final String? representative;

  @JsonKey(name: 'tax_code')
  final String? taxCode;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  final AddressDataModel? city;
  final AddressDataModel? district;
  final AddressDataModel? ward;

  @JsonKey(name: 'full_address')
  final String? fullAddress;

  @JsonKey(name: 'is_superuser')
  final bool? isSuperuser;
  final String? state;
  final String? note;
  final List<WarehouseModel>? warehouses;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'date_period')
  final List<DatePeriod>? datePeriod;
  final dynamic avatar;

  @JsonKey(name: 'modified_at')
  final DateTime? modifiedAt;

  @JsonKey(name: 'created_by')
  final AtedBy? createdBy;

  @JsonKey(name: 'updated_by')
  final AtedBy? updatedBy;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  @JsonKey(name: 'status_name')
  final String? statusName;
  final num? status;

  @JsonKey(name: 'type_label')
  final String? typeLabel;

  @JsonKey(name: 'type_name')
  final String? typeName;
  final num? type;

  factory UserModelV3.fromJson(Map<String, dynamic> json) =>
      _$UserModelV3FromJson(json);

  Map<String, dynamic> toJson() => _$UserModelV3ToJson(this);
}

@JsonSerializable()
class AtedBy {
  AtedBy({
    this.id,
    this.fullname,
  });

  final int? id;
  final String? fullname;

  factory AtedBy.fromJson(Map<String, dynamic> json) => _$AtedByFromJson(json);

  Map<String, dynamic> toJson() => _$AtedByToJson(this);
}

@JsonSerializable()
class DatePeriod {
  DatePeriod({
    this.openingDate,
    this.closingDate,
  });

  @JsonKey(name: 'opening_date')
  final DateTime? openingDate;

  @JsonKey(name: 'closing_date')
  final DateTime? closingDate;

  factory DatePeriod.fromJson(Map<String, dynamic> json) =>
      _$DatePeriodFromJson(json);

  Map<String, dynamic> toJson() => _$DatePeriodToJson(this);
}
