import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/widgets/address_selection/address_selection.dart';
import 'package:bpg_retail/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/common/title_required.dart';
import 'package:bpg_retail/core/widgets/store_address_selection/store_address_selection.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/profile/data/bloc/register_store_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/register_store_state.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

@RoutePage()
class RegisterStorePage extends StatefulWidget {
  const RegisterStorePage({super.key});

  @override
  State<RegisterStorePage> createState() => _RegisterStorePageState();
}

class _RegisterStorePageState extends State<RegisterStorePage> {
  late TextEditingController shopNameCtrl;
  late TextEditingController taxCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController managerCtrl;

  late GoogleMapController mController;
  final formKey = GlobalKey<FormState>();
  final navigator = getIt.get<AppNavigator>();
  final bloc = getIt.get<RegisterStoreCubit>();

  @override
  void initState() {
    super.initState();
    shopNameCtrl = TextEditingController();
    taxCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    managerCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterStoreCubit>(
      create: (context) => bloc,
      child: BaseScreen(
        title: "Đăng ký mở shop",
        isImageBg: false,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BaseContainer(
              padding: 16.pading,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thông tin shop", style: s16w500),
                    16.height,
                    requiredTitle("Tên shop"),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: shopNameCtrl,
                      radius: 12,
                      initialValue: "",
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập tên shop',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onChanged: (p0) {},
                      validator: (value) {
                        if (value?.nullOrEmpty == true) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    8.height,
                    const Text("Mã số thuế", style: s14w500),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: taxCtrl,
                      radius: 12,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      initialValue: "",
                      hintText: 'Nhập mã số thuế',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onChanged: (p0) {},
                    ),
                    24.height,
                    const Text("Thông tin kho hàng", style: s16w500),
                    16.height,
                    requiredTitle("Tên quản lý kho"),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: managerCtrl,
                      radius: 12,
                      initialValue: "",
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Họ và tên',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onChanged: (p0) {},
                      validator: (value) {
                        if (value?.nullOrEmpty == true) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    8.height,
                    requiredTitle("Số điện thoại quản lý"),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: phoneCtrl,
                      radius: 12,
                      initialValue: "",
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập số điện thoại',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onChanged: (p0) {},
                      validator: (value) {
                        final RegExp regex = RegExp(r'^0\d{9,11}$');
                        if (value!.isEmpty || !regex.hasMatch(value)) {
                          return "Số điện thoại không đúng định dạng";
                        }
                        return null;
                      },
                    ),
                    16.height,
                    requiredTitle("Địa chỉ"),
                    const SizedBox(height: 8),
                    BlocBuilder<RegisterStoreCubit, RegisterStoreState>(
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
                          radius: 12,
                          onTap: () async {
                            final result = await navigator.showBottomSheet(
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
                    BlocBuilder<RegisterStoreCubit, RegisterStoreState>(
                      builder: (context, state) {
                        List<double> latLog = [20.9984316, 105.7949591];
                        final AddressModel? address = state.address;
                        if (address != null &&
                            address.address != null &&
                            address.address.containsKey("locations") &&
                            address.address["locations"].length == 2) {
                          latLog = address.address["locations"].cast<double>();
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
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: latLog.any((e) => e != 0)
                                          ? Border.all(
                                              width: 1.2,
                                              color: AppColors.border_2,
                                            )
                                          : Border.all(width: 0),
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: latLog.any((e) => e != 0)
                                          ? Stack(
                                              children: [
                                                GoogleMap(
                                                  onMapCreated: (controller) =>
                                                      mController = controller,
                                                  onTap: (argument) async {},
                                                  rotateGesturesEnabled: false,
                                                  scrollGesturesEnabled: false,
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
                                                    assetName: "ic_map_pin.svg",
                                                  ),
                                                ),
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () async {},
                                              child: Container(
                                                decoration: const BoxDecoration(
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
                                                    "Vui lòng nhập địa chỉ",
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                  onTap: () {
                    navigator.back();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ExtraButton(
                  largeButton: false,
                  title: 'Gửi yêu cầu',
                  color: AppColors.white,
                  bgColor: AppColors.main,
                  borderColor: AppColors.main,
                  onTap: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    } else {
                      bloc.createGroceryAddress(
                        manager: managerCtrl.text,
                        phone: phoneCtrl.text,
                        tax: taxCtrl.text,
                        title: shopNameCtrl.text,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
