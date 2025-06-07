import 'package:bpg_retail/features/home/data/model/warehouse_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transection_detail_model.g.dart';

@JsonSerializable()
class TransectionDetailModel {
  TransectionDetailModel({
    this.id,
    this.customer,
    this.warehouseFrom,
    this.warehouseTo,
    this.createdBy,
    this.updatedBy,
    this.transactionItems,
    this.modifiedAt,
    this.createdAt,
    this.isDeleted,
    this.deletedAt,
    this.transactionCode,
    this.note,
    this.startDate,
    this.endDate,
    this.actualEndDate,
    this.expectedMoney,
    this.actualMoney,
  });

  final int? id;
  final CustomerClass? customer;

  @JsonKey(name: 'warehouse_from')
  final WarehouseModel? warehouseFrom;

  @JsonKey(name: 'warehouse_to')
  final WarehouseModel? warehouseTo;

  @JsonKey(name: 'created_by')
  final CustomerClass? createdBy;

  @JsonKey(name: 'updated_by')
  final CustomerClass? updatedBy;

  @JsonKey(name: 'transaction_items')
  final List<TransactionItem>? transactionItems;

  @JsonKey(name: 'modified_at')
  final DateTime? modifiedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;

  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;

  @JsonKey(name: 'transaction_code')
  final String? transactionCode;
  final String? note;

  @JsonKey(name: 'start_date')
  final DateTime? startDate;

  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  @JsonKey(name: 'actual_end_date')
  final dynamic actualEndDate;

  @JsonKey(name: 'expected_money')
  final num? expectedMoney;

  @JsonKey(name: 'actual_money')
  final num? actualMoney;

  factory TransectionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TransectionDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransectionDetailModelToJson(this);
}

@JsonSerializable()
class CustomerClass {
  CustomerClass({
    this.id,
    this.code,
    this.fullname,
    this.representative,
    this.phoneNumber,
    this.taxCode,
    this.type,
  });

  final int? id;
  final String? code;
  final String? fullname;
  final String? representative;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'tax_code')
  final String? taxCode;
  final num? type;

  factory CustomerClass.fromJson(Map<String, dynamic> json) =>
      _$CustomerClassFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerClassToJson(this);
}

@JsonSerializable()
class TransactionItem {
  TransactionItem({
    this.id,
    this.product,
    this.file,
    this.note,
    this.startDate,
    this.endDate,
    this.quantity,
    this.money,
    this.expectedMoney,
  });

  final int? id;
  final Product? product;
  final List<dynamic>? file;
  final String? note;

  @JsonKey(name: 'start_date')
  final DateTime? startDate;

  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final num? quantity;
  final num? money;

  @JsonKey(name: 'expected_money')
  final num? expectedMoney;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}

@JsonSerializable()
class Product {
  Product({
    this.id,
    this.productName,
    this.description,
    this.productCode,
    this.images,
    this.createdBy,
    this.modifiedAt,
    this.createdAt,
    this.productGroup,
    this.category,
  });

  final int? id;

  @JsonKey(name: 'product_name')
  final String? productName;
  final String? description;

  @JsonKey(name: 'product_code')
  final String? productCode;
  final List<Image>? images;

  @JsonKey(name: 'created_by')
  final ProductCreatedBy? createdBy;

  @JsonKey(name: 'modified_at')
  final DateTime? modifiedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'product_group')
  final dynamic productGroup;
  final Category? category;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Category {
  Category({
    this.id,
    this.categoryCode,
    this.categoryName,
  });

  final int? id;

  @JsonKey(name: 'category_code')
  final String? categoryCode;

  @JsonKey(name: 'category_name')
  final String? categoryName;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class ProductCreatedBy {
  ProductCreatedBy({
    this.id,
    this.fullname,
  });

  final int? id;
  final String? fullname;

  factory ProductCreatedBy.fromJson(Map<String, dynamic> json) =>
      _$ProductCreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCreatedByToJson(this);
}

@JsonSerializable()
class Image {
  Image({
    this.id,
    this.image,
  });

  final int? id;
  final String? image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
