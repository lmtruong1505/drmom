import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/base/base_state.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/spacing.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/utilities/dialog_utils.dart';
import 'package:BGP_Retail/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/common/custom_switch.dart';
import 'package:BGP_Retail/core/widgets/common/title_required.dart';
import 'package:BGP_Retail/core/widgets/store_address_selection/store_address_selection.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/profile/data/bloc/address_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/address_state.dart';
import 'package:BGP_Retail/features/profile/data/models/address_asbc_model.dart';
import 'package:BGP_Retail/features/profile/data/models/address_model.dart';
import 'package:BGP_Retail/features/profile/presentation/children_screens/widgets/address/address_fullscreen.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreateAddressPage extends StatefulWidget {
  const CreateAddressPage({super.key, this.address});

  final AsbcAddressModel? address;

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState
    extends BaseState<CreateAddressPage, AddressCubit> {
  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      bloc.initAddress(widget.address);
    }
  }

  late GoogleMapController mController;
  @override
  Widget buildPage(BuildContext context) {
    return BaseScreen(
      padding: 16,
      title: widget.address == null ? 'Thêm mới địa chỉ' : 'Cập nhật địa chỉ',
      body: BaseContainer(
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: bloc.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      requiredTitle("Họ tên"),
                      const SizedBox(height: 8),
                      BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          String initialValue = '';
                          if (state.address != null) {
                            initialValue = state.address!.fullname!;
                          }
                          return ValidateTextField(
                            initialValue: initialValue,
                            margin: EdgeInsets.zero,
                            backgroundColor: AppColors.white,
                            hintText: 'Nhập họ tên',
                            hintStyle: AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            ),
                            maxLines: 1,
                            onChanged: bloc.onChangeFullname,
                            validator: (value) {
                              if (value.nullOrEmpty) {
                                return 'Vui lòng chọn địa chỉ';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      requiredTitle("Số điện thoại"),
                      const SizedBox(height: 8),
                      BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          String initialValue = '';
                          if (state.address != null) {
                            initialValue = state.address!.phoneNumber!;
                          }
                          return ValidateTextField(
                            margin: EdgeInsets.zero,
                            backgroundColor: AppColors.white,
                            initialValue: initialValue,
                            hintText: 'Nhập số điện thoại',
                            hintStyle: AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            ),
                            maxLines: 1,
                            onChanged: bloc.onChangePhoneNumber,
                            validator: (value) {
                              final RegExp regex = RegExp(r'^0\d{9,11}$');
                              if (value!.isEmpty || !regex.hasMatch(value)) {
                                return "Số điện thoại không đúng định dạng";
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      requiredTitle("Địa chỉ"),
                      const SizedBox(height: 8),
                      BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          AddressSelectionModel addressSelection =
                              const AddressSelectionModel();
                          String initialValue = '';
                          if (state.address != null &&
                              state.address!.address != null &&
                              state.address!.address!['text'] != null) {
                            final address = state.address!.address;
                            initialValue = address!['text'];

                            addressSelection = AddressSelectionModel(
                              text: address['text'],
                              ward: address['ward'],
                              address: address['address'],
                              district: address['district'],
                              province: address['province'],
                              // locations: address["locations"],
                            );
                          }
                          return ValidateTextField(
                            onTap: () async {
                              final result =
                                  await bloc.navigator.showBottomSheet(
                                child: StoreAddressSelection(
                                  initialValue: addressSelection,
                                ),
                                backgroundColor: Colors.transparent,
                                enableDrag: true,
                              );
                              if (result != null) {
                                bloc.onChangeAddress(result);
                              }
                            },
                            margin: EdgeInsets.zero,
                            backgroundColor: AppColors.white,
                            hintText: initialValue.isEmpty
                                ? 'Tỉnh/ Thành phố, Quận/ Huyện, Phường/Xã'
                                : initialValue,
                            hintStyle: initialValue.isEmpty
                                ? AppTypography.p6.copyWith(
                                    color: AppColors.grey_1,
                                  )
                                : AppTypography.p5
                                    .copyWith(color: AppColors.black),
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.black,
                              size: 24,
                            ),
                            maxLines: 1,
                            readOnly: true,
                            validator: (_) {
                              if (initialValue.isEmpty) {
                                return 'Vui lòng chọn địa chỉ';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          List<double> latLog = [20.9984316, 105.7949591];
                          final AddressModel? address = state.address;
                          if (address != null &&
                              address.address != null &&
                              address.address.containsKey("locations") &&
                              address.address["locations"].length == 2) {
                            latLog =
                                address.address["locations"].cast<double>();
                          }
                          final kGooglePlex = CameraPosition(
                            target: LatLng(latLog[0], latLog[1]),
                            zoom: 13.5,
                          );
                          return state.isLoadingAddress == true
                              ? Container(
                                  height: 134,
                                  margin: const EdgeInsets.only(top: 24),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      width: 1.2,
                                      color: AppColors.border_2,
                                    ),
                                  ),
                                  child: const BaseLoading(),
                                )
                              : address != null &&
                                      address.address != null &&
                                      address.address!['text'] != null &&
                                      latLog.any((e) => e == 0)
                                  ? const SizedBox.shrink()
                                  : Container(
                                      height: 134,
                                      margin: const EdgeInsets.only(top: 24),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: latLog.any((e) => e != 0)
                                            ? Border.all(
                                                width: 1.2,
                                                color: AppColors.border_2,
                                              )
                                            : Border.all(width: 0),
                                      ),
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: latLog.any((e) => e != 0)
                                            ? Stack(
                                                children: [
                                                  GoogleMap(
                                                    onMapCreated:
                                                        (controller) =>
                                                            mController =
                                                                controller,
                                                    onTap: (argument) async {
                                                      final result = await bloc
                                                          .navigator
                                                          .push(
                                                        AddressFullScreenV2(
                                                          address: state
                                                                  .address ??
                                                              AddressModel(),
                                                        ),
                                                      );

                                                      if (result != null &&
                                                          result is Map<String,
                                                              dynamic>) {
                                                        // bloc.setLoading(true);

                                                        bloc.onSetAddress(
                                                            result);
                                                        Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                          () {
                                                            final locations = result[
                                                                        "address"]
                                                                    [
                                                                    "locations"]
                                                                .cast<double>();
                                                            mController
                                                                .animateCamera(
                                                              CameraUpdate
                                                                  .newCameraPosition(
                                                                CameraPosition(
                                                                  target:
                                                                      LatLng(
                                                                    locations?[
                                                                            0] ??
                                                                        0,
                                                                    locations?[
                                                                            1] ??
                                                                        0,
                                                                  ),
                                                                  zoom: 13.5,
                                                                ),
                                                              ),
                                                            );
                                                            EasyLoading
                                                                .dismiss();
                                                            // bloc.setLoading(false);
                                                          },
                                                        );
                                                      }
                                                    },
                                                    rotateGesturesEnabled:
                                                        false,
                                                    scrollGesturesEnabled:
                                                        false,
                                                    zoomControlsEnabled: false,
                                                    zoomGesturesEnabled: false,
                                                    myLocationButtonEnabled:
                                                        false,
                                                    mapType: MapType.normal,
                                                    initialCameraPosition:
                                                        kGooglePlex,
                                                  ),
                                                  Center(
                                                    child: Assets.icon(
                                                      assetName:
                                                          "ic_map_pin.svg",
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  final result = await bloc
                                                      .navigator
                                                      .showBottomSheet(
                                                    child: AddressFullScreen(
                                                      address: state.address ??
                                                          AddressModel(),
                                                    ),
                                                  );
                                                  if (result != null) {
                                                    bloc.setLoading(true);
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                        bloc.onSetAddress(
                                                            result);
                                                        bloc.setLoading(false);
                                                      },
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        "assets/images/default_map.png",
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "Vui lòng nhập địa chỉ"),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: Spacing.a16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 1.2,
                            color: AppColors.border_2,
                          ),
                        ),
                        child: BlocBuilder<AddressCubit, AddressState>(
                          builder: (context, state) {
                            bool isDefault = false;
                            if (state.address != null) {
                              isDefault = state.address!.isDefault!;
                            }
                            return CustomSwitch(
                              label:
                                  isDefault ? "Mặc định" : "Đặt làm mặc định",
                              value: isDefault,
                              onChanged: bloc.onSetAddressDefault,
                            );
                          },
                        ),
                      ),
                      BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          return state.address != null &&
                                  state.address!.id != null
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ExtraButton(
                                        largeButton: false,
                                        title: 'Xóa địa chỉ',
                                        onTap: () {
                                          DialogUtils.showConfirmDialog(
                                            context,
                                            description:
                                                "Bạn có muốn xoá địa chỉ?",
                                            ontap: () {},
                                          );
                                        },
                                        color: AppColors.red_1,
                                        borderColor: Colors.transparent,
                                        padding: Spacing.a16,
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                  ],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ExtraButton(
                largeButton: false,
                title: 'Huỷ bỏ',
                onTap: () => navigator.back(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ExtraButton(
                largeButton: false,
                title: widget.address == null ? 'Lưu lại' : 'Cập nhật',
                color: AppColors.white,
                bgColor: AppColors.main,
                borderColor: AppColors.main,
                onTap: () {
                  if (widget.address == null) {
                    bloc.createASBCAddress();
                  } else {
                    bloc.updateASBCAddress(widget.address?.id ?? 0);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
