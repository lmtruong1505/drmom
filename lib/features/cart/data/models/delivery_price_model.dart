import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_price_model.freezed.dart';
part 'delivery_price_model.g.dart';

@freezed
abstract class DeliveryPriceModel with _$DeliveryPriceModel {
  const DeliveryPriceModel._();

  const factory DeliveryPriceModel({
    @JsonKey(name: 'MA_DV_CHINH') String? maDvChinh,
    @JsonKey(name: 'TEN_DICHVU') String? tenDichvu,
    @JsonKey(name: 'GIA_CUOC') int? giaCuoc,
    @JsonKey(name: 'THOI_GIAN') String? thoiGian,
    @JsonKey(name: 'EXCHANGE_WEIGHT') int? exchangeWeight,
  }) = _DeliveryPriceModel;

  factory DeliveryPriceModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPriceModelFromJson(json);
}
