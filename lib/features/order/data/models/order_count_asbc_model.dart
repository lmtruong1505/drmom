import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_count_asbc_model.g.dart';
part 'order_count_asbc_model.freezed.dart';

@freezed
class OrderCountAsbcModel with _$OrderCountAsbcModel {
  const factory OrderCountAsbcModel({
    final int? id,
    final String? title,
    final String? code,
    final num? count,
  }) = _OrderCountAsbcModel;

  factory OrderCountAsbcModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCountAsbcModelFromJson(json);
}
