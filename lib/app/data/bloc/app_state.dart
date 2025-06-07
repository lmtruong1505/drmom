import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/cart/data/models/cart_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/features/product/data/models/category_model.dart';
import 'package:bpg_retail/features/product/data/models/formula_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:bpg_retail/features/profile/data/models/notification_model.dart';
import 'package:location/location.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingAddress,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isRemember,
    @Default(false) bool serviceEnabled,
    @Default(PermissionStatus.denied) PermissionStatus permissionGranted,
    @Default(null) String? avatar,
    @Default([]) List<FormulaModel> formulas,
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<BoothModel> booths,
    @Default(null) OrderModel? orderChange,
    @Default([]) List<CartModel> cartList,
    @Default([]) List<AddressModel> addressList,
    @Default([]) List<dynamic> provinces,
    @Default(null) BoothModel? boothSelected,
    @Default(false) isChecked,
    @Default([]) List<NotificationModel> notifyList,
    @Default(false)
    bool
        callNoti, // false: không nỏ toast noti || true: ần tới sẽ nỏ toast noti
    @Default("") String customId,
  }) = _AppState;
}
