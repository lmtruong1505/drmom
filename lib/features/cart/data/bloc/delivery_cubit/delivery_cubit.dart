import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/features/cart/data/models/delivery_model.dart';
import 'package:BGP_Retail/features/cart/data/repositories/delivery_repository.dart';

import '../../models/delivery_price_model.dart';
import 'delivery_state.dart';

@injectable
class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit(
    this._deliveryRepository,
  ) : super(const DeliveryState());

  final DeliveryRepository _deliveryRepository;

  String iSenderAddress = "";
  String iReceiverAddress = "";
  num? iWeight;
  num? iLength;
  num? iWidth;
  num? iHeight;
  num? iPrice;

  void setDeliveryData({
    required String senderAddress,
    required String receiverAddress,
    required num? weight,
    required num? length,
    required num? width,
    required num? height,
    required num? price,
  }) {
    iSenderAddress = senderAddress;
    iReceiverAddress = receiverAddress;
    iWeight = weight;
    iLength = length;
    iWeight = width;
    iHeight = height;
    iPrice = price;
    emit(
      state.copyWith(
        deliverySelect: DeliveryTypeModel(
          deliveryShipping: DeliveryShipping.pickUp,
          address: iSenderAddress,
        ),
      ),
    );
    getListViettelPost();
    if ((weight ?? 0) < 20) {
      getGHTK();
    }
  }

  void selectPriceHandle(DeliveryPriceModel? value) {
    emit(state.copyWith(itemSelected: value));
  }

  Future<void> getListPrice() async {
    final res = await _deliveryRepository.listPrice(
      senderAddress: iSenderAddress,
      receiverAddress: iReceiverAddress,
    );
    emit(
      state.copyWith(
        isLoading: false,
        list: res.data ?? [],
      ),
    );
  }

  Future<void> getListViettelPost() async {
    final res = await _deliveryRepository.getListViettelPost(
      senderAddress: iSenderAddress,
      receiverAddress: iReceiverAddress,
      weight: iWeight,
      height: iHeight,
      length: iLength,
      width: iWidth,
      price: iPrice,
    );
    emit(
      state.copyWith(
        isLoading: false,
        lstviettelPost: res.data ?? [],
      ),
    );
  }

  Future<void> getGHTK() async {
    final res = await _deliveryRepository.getGHTK(
      senderAddress: iSenderAddress,
      receiverAddress: iReceiverAddress,
      weight: iWeight,
      height: iHeight,
      length: iLength,
      width: iWidth,
      price: iPrice,
    );
    emit(state.copyWith(ghtk: res.data));
  }

  void onSelectDelivery(DeliveryTypeModel delivery) {
    emit(state.copyWith(deliverySelect: delivery));
  }
}
