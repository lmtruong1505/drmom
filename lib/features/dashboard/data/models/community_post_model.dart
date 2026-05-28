import 'package:json_annotation/json_annotation.dart';
import 'community_post_user_model.dart';

part 'community_post_model.g.dart';

@JsonSerializable()
class MediaTypeValueModel {
  final String? label;
  final int? value;

  MediaTypeValueModel({this.label, this.value});

  factory MediaTypeValueModel.fromJson(Map<String, dynamic> json) =>
      _$MediaTypeValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaTypeValueModelToJson(this);
}

@JsonSerializable()
class PostMediaModel {
  final int? id;
  @JsonKey(name: 'media_url')
  final String? mediaUrl;
  @JsonKey(name: 'media_type')
  final MediaTypeValueModel? mediaType;

  PostMediaModel({
    this.id,
    this.mediaUrl,
    this.mediaType,
  });

  factory PostMediaModel.fromJson(Map<String, dynamic> json) =>
      _$PostMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostMediaModelToJson(this);
}

@JsonSerializable()
class PostShareDataModel {
  final int? id;
  final int? type;
  final List<PostMediaModel>? media;
  final String? title;
  final String? content;
  final PostStatusValueModel? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final CommunityPostUserModel? user;
  @JsonKey(name: 'is_public')
  final bool? isPublic;
  @JsonKey(name: 'pin_status')
  final bool? pinStatus;

  PostShareDataModel({
    this.id,
    this.type,
    this.media,
    this.title,
    this.content,
    this.status,
    this.createdAt,
    this.user,
    this.isPublic,
    this.pinStatus,
  });

  factory PostShareDataModel.fromJson(Map<String, dynamic> json) =>
      _$PostShareDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostShareDataModelToJson(this);
}

@JsonSerializable()
class CommunityPostModel {
  final int? id;
  final int? type;
  final List<PostMediaModel>? media;
  final String? title;
  final String? content;
  final PostStatusValueModel? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final CommunityPostUserModel? user;
  @JsonKey(name: 'user_reaction')
  final int? userReaction;
  @JsonKey(name: 'comment_count')
  final int? commentCount;
  @JsonKey(name: 'is_public')
  final bool? isPublic;
  @JsonKey(name: 'pin_status')
  final bool? pinStatus;
  @JsonKey(name: 'share_count')
  final int? shareCount;
  @JsonKey(name: 'post_share_data')
  final PostShareDataModel? postShareData;
  @JsonKey(name: 'status_share')
  final bool? statusShare;
  @JsonKey(name: 'self_reaction')
  final dynamic selfReaction;
  @JsonKey(name: 'pin_news_post')
  final bool? pinNewsPost;
  @JsonKey(name: 'total_interact')
  final int? totalInteract;

  CommunityPostModel({
    this.id,
    this.type,
    this.media,
    this.title,
    this.content,
    this.status,
    this.createdAt,
    this.user,
    this.userReaction,
    this.commentCount,
    this.isPublic,
    this.pinStatus,
    this.shareCount,
    this.postShareData,
    this.statusShare,
    this.selfReaction,
    this.pinNewsPost,
    this.totalInteract,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostModelToJson(this);
}
