import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:bpg_retail/features/order/data/models/order_asbc_model.dart';
import 'package:bpg_retail/features/profile/data/models/deposit_qr_code_model.dart';

part 'order_detail_state.freezed.dart';

@freezed
class OrderDetailState with _$OrderDetailState {
  const factory OrderDetailState({
    @Default(null) QrOrderDetailModel? order,
    @Default([]) List<DataModel>? reason,
    @Default([]) List<DataModel>? listComplant,
    @Default(false) bool isLoading,
    @Default(false) bool hasUpdate,
    @Default(CubitStatus.init) CubitStatus status,
    DepositQrCodeModel? orderQrCode,
  }) = _OrderDetailState;
}
