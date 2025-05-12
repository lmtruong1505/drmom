import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_model.g.dart';
part 'delivery_model.freezed.dart';

@freezed
class DeliveryTypeModel with _$DeliveryTypeModel {
  const factory DeliveryTypeModel({
    final DeliveryShipping? deliveryShipping,
    final String? type,
    final String? code,
    final num? price,
    final String? time,
    final String? address,
  }) = _DeliveryTypeModel;

  factory DeliveryTypeModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryTypeModelFromJson(json);
}

enum DeliveryShipping {
  viettelPost,
  ghtk,
  pickUp;
}
