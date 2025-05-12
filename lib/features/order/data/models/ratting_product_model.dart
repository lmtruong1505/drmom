import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/features/order/data/models/order_detail_model.dart';

part 'ratting_product_model.g.dart';
part 'ratting_product_model.freezed.dart';

@freezed
class RatingProductModel with _$RatingProductModel {
  const factory RatingProductModel({
    final int? id,
    final num? star,
    @JsonKey(name: 'product') final int? productId,
    @JsonKey(ignore: true) final List<PlatformFile>? imagesFile,
    @JsonKey(name: "rating_image") final List<String>? images,
    final String? comment,
    final OrderItem? order,
  }) = _RatingProductModel;

  factory RatingProductModel.fromJson(Map<String, dynamic> json) =>
      _$RatingProductModelFromJson(json);
}
