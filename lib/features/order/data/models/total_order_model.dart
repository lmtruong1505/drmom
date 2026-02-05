import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_order_model.freezed.dart';
part 'total_order_model.g.dart';

@freezed
abstract class TotalOrderModel with _$TotalOrderModel {
  const factory TotalOrderModel({
    @JsonKey(name: 'PICKUP') final num? pickUp,
    @JsonKey(name: 'APPROVED') final num? approved,
    @JsonKey(name: 'DELIVERED') final num? delivered,
    @JsonKey(name: 'SHIPPING') final num? shipping,
    @JsonKey(name: 'RETURN') final num? totalOrderReturn,
    @JsonKey(name: 'CANCEL') final num? cancel,
    @JsonKey(name: 'DONE') final num? done,
  }) = _TotalOrderModel;
  factory TotalOrderModel.fromJson(Map<String, dynamic> json) =>
      _$TotalOrderModelFromJson(json);
}
