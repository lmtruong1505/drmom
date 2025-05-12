import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/order/data/bloc/total_order_state.dart';
import 'package:BGP_Retail/features/order/data/repositories/order_repository.dart';

@injectable
class TotalOrderCubit extends Cubit<TotalOrderState> {
  TotalOrderCubit(this._repository) : super(const TotalOrderState());
  final OrderRepository _repository;

  void getTotalOrder() async {
    emit(state.copyWith(status: CubitStatus.loading));
    try {
      final res = await _repository.getCountOrders();
      if (res.code == 200) {
        emit(state.copyWith(status: CubitStatus.loaded, totalOrder: res.data));
      } else {
        emit(state.copyWith(status: CubitStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  // void getTotalOrders() async {
  //   try {
  //     final res = await _repository.getCountOrders();
  //     if (res.code == 200) {
  //       emit(state.copyWith(
  //           count: res.data,  status: CubitStatus.loaded));
  //     } else {
  //       emit(state.copyWith( status: CubitStatus.loaded));
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         status: CubitStatus.loaded,
  //       ),
  //     );
  //   }
  // }
}
