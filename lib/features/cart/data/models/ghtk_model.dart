import 'package:json_annotation/json_annotation.dart';
import 'package:bpg_retail/features/cart/data/models/delivery_model.dart';

part 'ghtk_model.g.dart';

@JsonSerializable()
class ViettelPostModel {
  ViettelPostModel({
    this.maDvChinh,
    this.tenDichvu,
    this.giaCuoc,
    this.thoiGian,
    this.exchangeWeight,
    this.extraService,
    this.deliveryShipping,
  });

  @JsonKey(name: 'MA_DV_CHINH')
  final String? maDvChinh;
  @JsonKey(defaultValue: DeliveryShipping.viettelPost)
  final DeliveryShipping? deliveryShipping;
  @JsonKey(name: 'TEN_DICHVU')
  final String? tenDichvu;
  @JsonKey(name: 'GIA_CUOC', fromJson: _priceFromJson, toJson: _priceToJson)
  final num? giaCuoc;
  @JsonKey(name: 'THOI_GIAN')
  final String? thoiGian;
  @JsonKey(name: 'EXCHANGE_WEIGHT')
  final num? exchangeWeight;
  @JsonKey(name: 'EXTRA_SERVICE')
  final List<ExtraService>? extraService;

  /// Convert price từ JSON (tăng 20%)
  static num _priceFromJson(num? price) => (price ?? 0) * 1.2;

  /// Convert price về JSON (giữ nguyên)
  static num _priceToJson(num? price) => (price ?? 0) / 1.2;

  factory ViettelPostModel.fromJson(Map<String, dynamic> json) =>
      _$ViettelPostModelFromJson(json);
}

@JsonSerializable()
class ExtraService {
  ExtraService({
    this.serviceCode,
    this.serviceName,
    this.description,
  });

  @JsonKey(name: 'SERVICE_CODE')
  final String? serviceCode;
  @JsonKey(name: 'SERVICE_NAME')
  final String? serviceName;
  @JsonKey(name: 'DESCRIPTION')
  final dynamic description;

  factory ExtraService.fromJson(Map<String, dynamic> json) =>
      _$ExtraServiceFromJson(json);
}

@JsonSerializable()
class GHTKModel {
  GHTKModel({
    this.moneyTotal,
    this.moneyVat,
  });

  @JsonKey(name: 'MONEY_TOTAL')
  final num? moneyTotal;
  @JsonKey(name: 'MONEY_VAT')
  final num? moneyVat;

  factory GHTKModel.fromJson(Map<String, dynamic> json) =>
      _$GHTKModelFromJson(json);
}
