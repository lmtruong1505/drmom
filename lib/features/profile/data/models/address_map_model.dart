import 'package:json_annotation/json_annotation.dart';

part 'address_map_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AddressMapModel {
  AddressMapModel({
    this.addressComponents,
    this.formattedAddress,
  });

  @JsonKey(name: 'address_components')
  final List<AddressComponent>? addressComponents;

  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;

  factory AddressMapModel.fromJson(Map<String, dynamic> json) =>
      _$AddressMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressMapModelToJson(this);
}

@JsonSerializable()
class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  @JsonKey(name: 'long_name')
  final String? longName;

  @JsonKey(name: 'short_name')
  final String? shortName;
  final List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}
