import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  @JsonKey(name: 'ma_tai_khoan')
  final String? maTaiKhoan;
  @JsonKey(name: 'tai_khoan')
  final String? taiKhoan;
  @JsonKey(name: 'ho_va_ten')
  final String? hoVaTen;
  @JsonKey(name: 'dien_thoai')
  final String? dienThoai;
  final String? email;
  @JsonKey(name: 'ma_so_thue')
  final String? maSoThue;
  @JsonKey(name: 'dia_chi')
  final String? diaChi;
  @JsonKey(name: 'hinh_anh')
  final String? hinhAnh;
  @JsonKey(name: 'ngay_sinh')
  final String? birthday;
  @JsonKey(name: 'gioi_tinh')
  final ValueLabelModel? gioiTinh;
  @JsonKey(name: 'so_cccd')
  final String? identified;
  @JsonKey(name: 'ngay_cap_cccd')
  final String? dateProvided;
  @JsonKey(name: 'noi_cap_cccd')
  final String? placeProvided;
  @JsonKey(name: 'image_front')
  final String? imageFront;
  @JsonKey(name: 'image_back')
  final String? imageBack;
  final List<dynamic>? warehouses;
  @JsonKey(name: 'date_period')
  final List<dynamic>? datePeriod;
  @JsonKey(name: 'trang_thai')
  final ValueLabelModel? trangThai;
  @JsonKey(name: 'created_by')
  final CreatedByModel? createdBy;

  UserModel({
    this.id,
    this.maTaiKhoan,
    this.taiKhoan,
    this.hoVaTen,
    this.dienThoai,
    this.email,
    this.maSoThue,
    this.diaChi,
    this.hinhAnh,
    this.trangThai,
    this.gioiTinh,
    this.createdBy,
    this.birthday,
    this.identified,
    this.dateProvided,
    this.placeProvided,
    this.imageFront,
    this.imageBack,
    this.warehouses,
    this.datePeriod,
  });

  // Getters for compatibility
  String get fullName => hoVaTen ?? '';
  String get phone => dienThoai ?? '';
  String get avatar => hinhAnh ?? '';
  int? get gender =>
      gioiTinh?.value is int
          ? gioiTinh?.value
          : (gioiTinh?.value is String ? int.tryParse(gioiTinh?.value) : null);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class ValueLabelModel {
  final String? label;
  final dynamic value;

  ValueLabelModel({this.label, this.value});

  factory ValueLabelModel.fromJson(Map<String, dynamic> json) =>
      _$ValueLabelModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValueLabelModelToJson(this);
}

@JsonSerializable()
class CreatedByModel {
  final int? id;
  @JsonKey(name: 'ho_va_ten')
  final String? hoVaTen;
  @JsonKey(name: 'ma_tai_khoan')
  final String? maTaiKhoan;

  CreatedByModel({this.id, this.hoVaTen, this.maTaiKhoan});

  factory CreatedByModel.fromJson(Map<String, dynamic> json) =>
      _$CreatedByModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatedByModelToJson(this);
}
