import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location/location.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingAddress,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isRemember,
    @Default(false) bool serviceEnabled,
    @Default(PermissionStatus.denied) PermissionStatus permissionGranted,
    @Default(null) String? avatar,
    @Default([]) List<dynamic> provinces,
    @Default(false) isChecked,
    @Default(false)
    bool
    callNoti, // false: không nỏ toast noti || true: ần tới sẽ nỏ toast noti
    @Default("") String customId,
  }) = _AppState;
}
