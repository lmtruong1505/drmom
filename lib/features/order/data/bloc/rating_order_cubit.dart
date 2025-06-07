import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/features/order/data/bloc/ratting_order_state.dart';
import 'package:bpg_retail/features/order/data/models/order_detail_model.dart';
import 'package:bpg_retail/features/order/data/repositories/order_repository.dart';

@injectable
class RattingOrderCubit extends Cubit<RattingOrderState> {
  RattingOrderCubit(this._orderRepository) : super(const RattingOrderState());

  final OrderRepository _orderRepository;
  final navigator = getIt.get<AppNavigator>();

  void initData(OrderDetailModel order) {
    emit(state.copyWith(order: order));
  }

  Future pickImage(int id) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,

        // allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        List<PlatformFile> imageTemporary = [];
        if (result.files.length > 5) {
          imageTemporary = result.files.sublist(0, 5);
        } else {
          imageTemporary = result.files;
        }
        final double allFileSize = bytesToMegabytes(
          imageTemporary.map((e) => e.size).reduce((v, e) => v + e),
        );
        if (allFileSize > 15) {
          navigator.showErrorSnackBar("Dung lượng tệp tối đa chỉ được 15MB");
          return;
        }
        final updateOrder = state.order!.orderItems!.map((element) {
          if (element.productId == id) {
            element = element.copyWith(
              files: imageTemporary.map((e) => e.path!).toList(),
            );
          }
          return element;
        }).toList();

        emit(
          state.copyWith(order: state.order?.copyWith(orderItems: updateOrder)),
        );
      }
    } catch (e) {}
  }

  void createOrderRating(int? productId) async {
    emit(state.copyWith(isLoading: true, status: CubitStatus.loading));
    final order = state.order?.orderItems
        ?.firstWhere((element) => element.productId == productId);
    final res =
        await _orderRepository.createRatting(order!, state.order?.orderId);
    if (res.code == 200) {
      // final newOrderItem = state.order?.orderItems?.map((e) {
      //   if (e.productId == productId) {
      //     e = e.copyWith(isUpdate: false);
      //   }
      //   return e;
      // }).toList();
      emit(
        state.copyWith(
          status: CubitStatus.sendSuccess,
          hasUpdate: true,
          isLoading: false,
          // order: state.order?.copyWith(orderItems: newOrderItem),
        ),
      );
    } else {
      emit(state.copyWith(status: CubitStatus.sendFaild, isLoading: false));
    }
  }

  // void changeEditOrderItem({required bool isEdit, required int id}) {
  //   final orderItemsUpdate = state.order?.orderItems?.map(
  //     (element) {
  //       if (element.productId == id) {
  //         element = element.copyWith(isUpdate: isEdit);
  //       }
  //       return element;
  //     },
  //   ).toList();
  //   emit(
  //     state.copyWith(
  //       order: state.order?.copyWith(orderItems: orderItemsUpdate),
  //     ),
  //   );
  // }

  void changeRatting(int? productId, {double? rating, String? note}) {
    final orderItemsUpdate = state.order?.orderItems?.map(
      (element) {
        if (element.productId == productId) {
          final newRatting = element.ratting?.copyWith(
            star: rating ?? element.ratting?.star,
            comment: note ?? element.ratting?.comment,
          );
          element = element.copyWith(ratting: newRatting);
        }
        return element;
      },
    ).toList();
    emit(
      state.copyWith(
        order: state.order?.copyWith(orderItems: orderItemsUpdate),
      ),
    );
  }

  void removeImage(int index, int id) {
    final lstImg = state.order?.orderItems
        ?.firstWhere((element) => element.productId == id)
        .files;
    final lisClone = List<String>.from(lstImg!);
    lisClone.remove(lstImg[index]);
    final newOrderItem = state.order?.orderItems?.map((e) {
      if (e.productId == id) {
        e = e.copyWith(files: lisClone);
      }
      return e;
    }).toList();
    emit(
      state.copyWith(order: state.order?.copyWith(orderItems: newOrderItem)),
    );
  }
}
