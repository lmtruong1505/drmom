import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booth_model.g.dart';

@JsonSerializable()
class BoothModel {
  final int id;
  final String? avatar;
  final String fullname;
  final String username;
  @JsonKey(name: 'full_address')
  final String? fullAddress;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? address;
  final String? ward;
  final String? city;
  final double? distance;
  @JsonKey(name: 'total_product')
  final int? totalProduct;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final bool? isView;
  @JsonKey(name: 'location_long')
  final double? locationLong;
  @JsonKey(name: 'location_lat')
  final double? locationLat;
  final int? sell;

  BoothModel({
    required this.id,
    required this.fullname,
    required this.username,
    this.avatar,
    this.phoneNumber,
    this.fullAddress,
    this.address,
    this.ward,
    this.city,
    this.distance,
    this.totalProduct,
    this.createdAt,
    this.isView,
    this.locationLong,
    this.locationLat,
    this.sell,
  });

  factory BoothModel.fromJson(Map<String, dynamic> json) =>
      _$BoothModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoothModelToJson(this);
}
