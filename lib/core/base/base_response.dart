import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

String baseResponseModelToJson(BaseResponseModel data) =>
    json.encode(data.toJson());

class BaseResponseModel<T> {
  final int? status;
  final bool? success;
  final String? message;
  final T? data;
  final dynamic metadata;

  BaseResponseModel({
    this.status,
    this.success,
    this.message,
    this.data,
    this.metadata,
  });

  BaseResponseModel<T> copyWith({
    int? status,
    bool? success,
    String? message,
    T? data,
    dynamic metadata,
  }) =>
      BaseResponseModel(
        status: status ?? this.status,
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        metadata: metadata ?? this.metadata,
      );

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
      BaseResponseModel(
        status: json['status'],
        success: json['success'],
        message: json['message'],
        data: json['data'],
        metadata: json['metadata'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'success': success,
        'message': message,
        'data': data,
        'metadata': metadata,
      };
}
