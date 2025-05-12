import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

@JsonSerializable()
class FAQModel {
  final int? id;
  final String? question;
  final int? type;
  final int? group;
  final int? status;
  final String? response;
  @JsonKey(name: 'created_date')
  final String? createdDate;
  @JsonKey(name: 'updated_date')
  final String? updatedDate;
  @JsonKey(name: 'user_created')
  final int? userCreated;
  @JsonKey(name: 'user_updated')
  final int? userUpdated;
  @JsonKey(name: 'list_system')
  final List<String>? listSystem;
  @JsonKey(name: 'user_name')
  final String? userName;
  @JsonKey(name: 'user_updated_name')
  final String? userUpdatedName;
  @JsonKey(name: 'group_name')
  final String? groupName;
  @JsonKey(name: 'ans_file')
  final List<String>? ansFile;
  @JsonKey(name: 'ask_file')
  final List<String>? askFile;

  FAQModel({
    this.id,
    this.question,
    this.type,
    this.group,
    this.status,
    this.response,
    this.createdDate,
    this.updatedDate,
    this.userCreated,
    this.userUpdated,
    this.listSystem,
    this.userName,
    this.userUpdatedName,
    this.groupName,
    this.ansFile,
    this.askFile,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) =>
      _$FAQModelFromJson(json);

  Map<String, dynamic> toJson() => _$FAQModelToJson(this);
}

@JsonSerializable()
class FAQGroupModel {
  final int id;
  @JsonKey(name: 'question_group_name')
  final String questionGroupName;

  FAQGroupModel({
    required this.id,
    required this.questionGroupName,
  });

  factory FAQGroupModel.fromJson(Map<String, dynamic> json) =>
      _$FAQGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$FAQGroupModelToJson(this);
}
