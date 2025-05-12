import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final int? id;
  @JsonKey(name: 'object_account_id')
  final int? objectAccountId;
  final String? fullname;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final dynamic address;
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  final List<double>? locations;

  AddressModel({
    this.id,
    this.objectAccountId,
    this.fullname,
    this.phoneNumber,
    this.address,
    this.isDefault,
    this.locations,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
