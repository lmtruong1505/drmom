import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/cart/data/models/qr_order_detail_model.dart';
import 'package:BGP_Retail/features/order/data/models/order_asbc_model.dart';
import 'package:BGP_Retail/features/profile/data/models/deposit_qr_code_model.dart';

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
