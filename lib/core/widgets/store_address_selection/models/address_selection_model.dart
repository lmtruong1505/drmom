import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_selection_model.g.dart';

@JsonSerializable()
class AddressSelectionModel {
  final String? text;
  final dynamic ward;
  final String? address;
  final dynamic district;
  final dynamic province;
  final List<double>? locations;

  const AddressSelectionModel({
    this.text,
    this.ward,
    this.address,
    this.district,
    this.province,
    this.locations,
  });

  factory AddressSelectionModel.fromJson(Map<String, dynamic> json) =>
      _$AddressSelectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressSelectionModelToJson(this);
}
