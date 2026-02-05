import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/profile/data/models/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(false) bool isFilter,
    @Default(false) bool isLoading,
    @Default(false) bool isChecked,
    @Default(false) bool isDeleteMany,
    @Default("") String notificationType,
    @Default([]) List<int>? lstNotiUnread,
    @Default([]) List<int>? lstNotiReaded,
    @Default(null) int? filter,
    @Default(0) int? totalUnread,
    @Default(0) int? totalReaded,
    @Default([]) List<NotificationModel> notifyListFB,
    @Default([]) List<NotificationModel> notifyListDB,
    @Default(CubitStatus.init) CubitStatus status,
  }) = _NotificationState;
}
