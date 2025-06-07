import 'package:freezed_annotation/freezed_annotation.dart';

part 'transection_model.g.dart';
part 'transection_model.freezed.dart';

@freezed
class TransectionModel with _$TransectionModel {
  const factory TransectionModel({
    final int? id,
    @JsonKey(name: 'transaction_code') final String? transactionCode,
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'warehouse_from_data') final String? warehouseFromData,
    @JsonKey(name: 'warehouse_to_data') final String? warehouseToData,
    @JsonKey(name: 'total_quantity') final num? totalQuantity,
    @JsonKey(name: 'transaction_type') final String? transactionType,
    @JsonKey(name: 'stock_in_time') final num? stockInTime,
    @JsonKey(name: 'hire_charges') final num? hireCharges,
    @JsonKey(name: 'total_day') final num? totalDay,
  }) = _TransectionModel;

  factory TransectionModel.fromJson(Map<String, dynamic> json) =>
      _$TransectionModelFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: 'open_balance') final num? openBalance,
    final num? money,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
