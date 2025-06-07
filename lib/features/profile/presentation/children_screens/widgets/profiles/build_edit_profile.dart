import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/bottom_sheet_service.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/image_utils.dart';
import 'package:bpg_retail/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:bpg_retail/core/widgets/avatar_widget.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/buttons/filter_button.dart';
import 'package:bpg_retail/core/widgets/cach_avatar_image.dart';
import 'package:bpg_retail/core/widgets/date_time_custom.dart';
import 'package:bpg_retail/core/widgets/datetime_picker.dart';
import 'package:bpg_retail/core/widgets/dropdown_buttom_widget.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:bpg_retail/core/widgets/identity_card_widget.dart';
import 'package:bpg_retail/core/widgets/store_address_selection/store_address_selection.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/authentication/data/models/profile_model.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/profile_state.dart';
import 'package:bpg_retail/features/profile/data/bloc/user_profile_cubit.dart';
import 'package:bpg_retail/features/profile/data/models/address_asbc_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/payment_detail_sreen.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/tabs/profile_info.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/widgets/address/address_fullscreen.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/widgets/profiles/build_preview_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../gen/assets.gen.dart';

Widget buildField(
  BuildContext context,
  ProfileModel profile,
  ProfileCubit bloc,
  int index,
) {
  switch (profile.field) {
    case 'date_of_birth':
      return DatetimePicker(
        defaultValue: profile.value,
        onConfirm: (date) {
          bloc.onChangeProfile(
            'date_of_birth',
            convertDateYYYYMMDDNormal(date),
          );
        },
      );
    case 'sex':
      final items = <DropdownButtonModel>[
        DropdownButtonModel(label: "Nam", value: 1),
        DropdownButtonModel(label: "Nữ", value: 0),
      ];

      return CustomDropdownButton(
        items: items,
        value: profile.value,
        onChanged: (DropdownButtonModel? value) {
          bloc.onChangeProfile('sex', value?.value);
        },
      );
    default:
      return const SizedBox.shrink();
  }
}

List<Widget> buildFields(
  BuildContext context,
  ProfileCubit bloc,
  ProfileState state,
) {
  final profiles = (state.userEdit?.profiles ?? [])
      .where(
        (e) => e.field != 'avatar',
      )
      .toList();

  return List.generate(
    profiles.length,
    (index) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          mapProfileTitle(profiles[index].field ?? ''),
          style: AppTypography.p5,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        buildField(
          context,
          profiles[index],
          bloc,
          index,
        ),
      ],
    ),
  );
}

// Widget buildEditProfile(
//   BuildContext context,
//   ProfileCubit bloc,
//   TextEditingController? starDate,
//   String defaultNow,
//   DateTime now,
// ) {
//   late GoogleMapController mController;
//   print("========widget build");
//   return }

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.bloc});
  final UserProfileCubit bloc;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late GoogleMapController mController;
  TextEditingController? birthdayCtrl;
  TextEditingController? nameCtrl;
  TextEditingController? emailCtrl;
  TextEditingController? genderCtrl;
  TextEditingController? placeProvidedCtrl;
  TextEditingController? indentifyDateCtrl;
  TextEditingController? indentifyCtrl;
  final now = DateTime.now();
  final format = DateFormat('yyyy-MM-dd');
  late String defaultNow;
  late String initialAddress;
  late AddressSelectionModel addressSelection;
  List<double> latLog = [20.9984316, 105.7949591];

  late CameraPosition kGooglePlex;
  final navigator = getIt.get<AppNavigator>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    final userData = widget.bloc.userData;

    birthdayCtrl = TextEditingController(
      text: userData.birthday.validator.toDateTimeFormat,
    );
    nameCtrl = TextEditingController(text: userData.fullName.validator);
    genderCtrl =
        TextEditingController(text: convertGender(userData.gender ?? 0));
    placeProvidedCtrl = TextEditingController(
      text: userData.placeProvided ?? "Cục cảnh sát quản lý HC về TTXH",
    );
    indentifyDateCtrl = TextEditingController(
      text: userData.dateProvided.validator.toDateTimeFormat,
    );
    indentifyCtrl = TextEditingController(text: userData.identified.validator);
    emailCtrl = TextEditingController(text: userData.email.validator);

    defaultNow = format.format(DateTime.now());
    setAddress(userData.address);
  }

  void setAddress(AddressData? addressData) {
    addressSelection = const AddressSelectionModel();
    if (addressData != null) {
      latLog = [
        (addressData.lat ?? 0).toDouble(),
        (addressData.long ?? 0).toDouble(),
      ];

      addressSelection = AddressSelectionModel(
        text: addressData.addressFull,
        ward: addressData.ward?.toJson(),
        address: addressData.title,
        district: addressData.district?.toJson(),
        province: addressData.province?.toJson(),
        locations: latLog,
      );
      widget.bloc.onChangeAddress(addressSelection.toJson());
      // widget.bloc.setUserAddress(addressSelection);
    }
  }

  List<FilterButtonModel> genders = [
    const FilterButtonModel(title: "Nam", value: 1),
    const FilterButtonModel(title: "Nữ", value: 2),
    const FilterButtonModel(title: "Khác", value: 3),
  ];
  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;

    return BaseScreen(
      padding: 16,
      title: 'Chỉnh sửa thông tin',
      body: SingleChildScrollView(
        child: BaseContainer(
          padding: 16.pading,
          child: BlocBuilder<UserProfileCubit, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              final address = bloc.userAddress?.address;
              final initialAddress =
                  address != null && address.containsKey("text")
                      ? address["text"]
                      : "";
              final lstLatLong =
                  address != null && address.containsKey("locations")
                      ? address["locations"]
                      : [0.0, 0.0];
              if (lstLatLong.isNotEmpty) {
                kGooglePlex = CameraPosition(
                  target: LatLng(lstLatLong[0], lstLatLong[1]),
                  zoom: 13.5,
                );
                latLog = [lstLatLong[0], lstLatLong[1]];
              }

              return Form(
                key: bloc.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin cá nhân",
                      style: s16w500,
                    ),
                    16.height,
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Ảnh đại diện",
                        style: AppTypography.p5,
                      ),
                    ),
                    8.height,
                    Align(
                      alignment: Alignment.center,
                      child: AvatarCustom(
                        size: 160,
                        onTap: () {
                          BottomSheetService.showBottomSheetSelectImageV2(
                            context: context,
                            onTapGallary: (p0) async => bloc.pickImageIdentity(
                              ImageIdentityTypeEnum.other,
                              p0,
                            ),
                            onTapCamera: () async {
                              _shotAvatar(bloc, context);
                            },
                            cropStyle: CropStyle.circle,
                          );
                        },
                        path: bloc.avatar,
                        url: bloc.userData.avatar,
                      ),
                    ),
                    16.height,
                    const Text(
                      'Họ tên',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: nameCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập họ và tên',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Hãy nhập họ và tên';
                        }
                        value = value!.trim();
                        if (value.isEmpty) {
                          return 'Hãy nhập họ và tên';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    const Text(
                      'Email',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: emailCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập mail',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Hãy nhập email';
                        }
                        value = value!.trim();
                        if (!value.isEmail()) {
                          return 'Email k đúng định dạng';
                        }
                        return null;
                      },
                    ),
                    16.height,
                    const Text(
                      'Ngày sinh',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    4.height,
                    ValidateTextField(
                      readOnly: true,
                      controller: birthdayCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập ngày sinh',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onTap: _onSelectBirtday,
                      validator: (value) {
                        if (value.nullOrEmpty) {
                          return "Bạn chưa chọn ngày sinh";
                        }
                        return null;
                      },
                    ),
                    16.height,
                    const Text(
                      'Giới tính',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    4.height,
                    DropdownButtonWidget<FilterButtonModel>(
                      hintText: "Chọn giới tính",
                      text: genderCtrl?.text,
                      onChanged: (p0) {
                        genderCtrl?.text = p0?.title ?? "";
                        bloc.updateGender();
                      },
                      items: genders.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.title,
                            style: s14w500.copyWith(
                              color: AppColors.blackish,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    16.height,
                    const Text(
                      'Địa chỉ',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    ValidateTextField(
                      onTap: () async {
                        final result = await bloc.navigator.showBottomSheet(
                          child: StoreAddressSelection(
                            initialValue: addressSelection,
                          ),
                          backgroundColor: Colors.transparent,
                          enableDrag: true,
                        );
                        if (result != null) {
                          final input = AddressData(
                            title: result["address"],
                            // lat: re,
                            // long,
                            province: Province.fromJson(result["province"]),
                            district: District.fromJson(result["district"]),
                            ward: District.fromJson(result["ward"]),
                            addressFull: result["text"],
                          );
                          setAddress(input);
                          bloc.onChangeAddress(result);
                        }
                      },
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: initialAddress.isEmpty
                          ? 'Tỉnh/ Thành phố, Quận/ Huyện, Phường/Xã'
                          : initialAddress,
                      hintStyle: initialAddress.isEmpty
                          ? AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            )
                          : AppTypography.p5.copyWith(color: AppColors.black),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.black,
                        size: 24,
                      ),
                      maxLines: 1,
                      readOnly: true,
                      validator: (_) {
                        if (initialAddress == null) {
                          return 'Vui lòng chọn địa chỉ';
                        }
                        return null;
                      },
                    ),
                    if (state.status == CubitStatus.loading)
                      Container(
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
                    else
                      Container(
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
                          child:
                              // latLog.any((e) => e != 0)?

                              Stack(
                            children: [
                              GoogleMap(
                                onMapCreated: (controller) =>
                                    mController = controller,
                                onTap: (argument) async {
                                  _onMapSelect();
                                },
                                rotateGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: false,
                                myLocationButtonEnabled: false,
                                mapType: MapType.normal,
                                initialCameraPosition: kGooglePlex,
                              ),
                              Center(
                                child: Assets.icons.icMapPin.svg(),
                              ),
                            ],
                          ),
                          // : GestureDetector(
                          //     onTap: () async {
                          //       _onSelectAddress(bloc);
                          //     },
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         image: DecorationImage(
                          //           image: AssetImage(
                          //             Assets.images.defaultMap.path,
                          //           ),
                          //           fit: BoxFit.fill,
                          //         ),
                          //       ),
                          //       child: const Align(
                          //         alignment: Alignment.center,
                          //         child: Text("Vui lòng nhập địa chỉ"),
                          //       ),
                          //     ),
                          //   ),
                        ),
                      ),
                    24.height,
                    const Text(
                      "Thông tin định danh",
                      style: s16w500,
                    ),
                    16.height,
                    const Text(
                      'Số CCCD',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: indentifyCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập số CCCD',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      validator: (value) {
                        if (value.nullOrEmpty) {
                          return "Bạn chưa nhập số CCCD";
                        }
                        return null;
                      },
                    ),
                    16.height,
                    const Text(
                      'Ngày cấp',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    4.height,
                    ValidateTextField(
                      controller: indentifyDateCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập ngày cấp CCCD',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onTap: _onSelectIndentifyDate,
                      validator: (value) {
                        if (value.nullOrEmpty) {
                          return "Bạn chưa nhập ngày cấp CCCD";
                        }
                        return null;
                      },
                    ),
                    16.height,
                    const Text(
                      'Nơi cấp',
                      style: AppTypography.p5,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    ValidateTextField(
                      controller: placeProvidedCtrl,
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Nhập nơi cấp CCCD',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      validator: (value) {
                        if (value.nullOrEmpty) {
                          return "Bạn chưa nhập nơi cấp CCCD";
                        }
                        return null;
                      },
                    ),
                    16.height,
                    Row(
                      children: [
                        Expanded(
                          child: IdentityCardWidgetV2(
                            url: bloc.userData.imageFront,
                            type: ImageIdentityTypeEnum.front,
                            path: bloc.frontUrl,
                            onTap: () {
                              BottomSheetService.showBottomSheetSelectImageV2(
                                context: context,
                                onTapGallary: (p0) async =>
                                    bloc.pickImageIdentity(
                                  ImageIdentityTypeEnum.front,
                                  p0,
                                ),
                                onTapCamera: () async {
                                  _shotFontCamera(bloc, context);
                                },
                              );
                            },
                          ),
                        ),
                        16.width,
                        Expanded(
                          child: IdentityCardWidgetV2(
                            url: bloc.userData.imageBack,
                            type: ImageIdentityTypeEnum.back,
                            path: bloc.backUrl,
                            onTap: () {
                              BottomSheetService.showBottomSheetSelectImageV2(
                                context: context,
                                onTapGallary: (p0) async =>
                                    bloc.pickImageIdentity(
                                  ImageIdentityTypeEnum.back,
                                  p0,
                                ),
                                onTapCamera: () async =>
                                    _shotBackCamera(bloc, context),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
                onTap: () => bloc.onChangeEdit(false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ExtraButton(
                largeButton: false,
                title: 'Lưu lại',
                color: AppColors.white,
                bgColor: AppColors.main,
                borderColor: AppColors.main,
                onTap: () => bloc.onAsbcUpdate(
                  email: emailCtrl?.text,
                  birthday: convertDateFormat(birthdayCtrl?.text ?? ""),
                  name: nameCtrl?.text,
                  dateProvided:
                      convertDateFormat(indentifyDateCtrl?.text ?? ""),
                  identified: indentifyCtrl?.text,
                  placeProvided: placeProvidedCtrl?.text,
                  gender: decodeGender(genderCtrl?.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convertDateFormat(String inputDate) {
    // Định dạng đầu vào
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    // Định dạng đầu ra
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    // Phân tích chuỗi đầu vào thành đối tượng DateTime
    final DateTime date = inputFormat.parse(inputDate);

    // Chuyển đổi thành chuỗi với định dạng mới
    final String outputDate = outputFormat.format(date);
    return outputDate;
  }

  void _shotFontCamera(UserProfileCubit bloc, BuildContext context) async {
    nav.pop();
    final result = await nav.push(
      KycCameraIdentityScreen(
        type: ImageIdentityTypeEnum.front,
      ),
    );

    if (result != null && result is XFile) {
      final imageCrop =
          ImageUtils.cropIdentityImage(context: context, file: result);
      bloc.setUrl(
        ImageIdentityTypeEnum.front,
        null,
      );
      bloc.setUrl(
        ImageIdentityTypeEnum.front,
        imageCrop,
      );
    }
  }

  void _shotBackCamera(UserProfileCubit bloc, BuildContext context) async {
    nav.pop();
    final result = await nav.push(
      KycCameraIdentityScreen(
        type: ImageIdentityTypeEnum.back,
      ),
    );

    if (result != null && result is XFile) {
      final imageCrop =
          ImageUtils.cropIdentityImage(context: context, file: result);
      bloc.setUrl(
        ImageIdentityTypeEnum.back,
        null,
      );
      bloc.setUrl(
        ImageIdentityTypeEnum.back,
        imageCrop,
      );
    }
  }

  void _shotAvatar(UserProfileCubit bloc, BuildContext context) async {
    nav.pop();
    final result = await nav.push(const KycCameraPortraitScreen());

    if (result != null && result is XFile) {
      final imageCrop =
          ImageUtils.cropIdentityImage(context: context, file: result);
      bloc.setUrl(
        ImageIdentityTypeEnum.other,
        null,
      );
      bloc.setUrl(
        ImageIdentityTypeEnum.other,
        imageCrop,
      );
    }
  }

  void _onSelectIndentifyDate() async {
    final res = await DateTimeCustom.datePickerCustom(
      context: context,
      initialDate: indentifyDateCtrl?.text,
    );
    if (res is DateTime) {
      indentifyDateCtrl?.text = res.toTextDefaulft;
    }
  }

  void _onSelectBirtday() async {
    final res = await DateTimeCustom.datePickerCustom(
      context: context,
      initialDate: birthdayCtrl?.text,
    );

    if (res is DateTime) {
      birthdayCtrl?.text = res.toTextDefaulft;
    }
  }

  void _onSelectAddress(ProfileCubit bloc) async {
    final result = await bloc.navigator.showBottomSheet(
      child: AddressFullScreen(
        address: bloc.state.address ?? AddressModel(),
      ),
    );
    if (result != null) {
      bloc.setLoading(true);
      Future.delayed(
        const Duration(
          milliseconds: 100,
        ),
        () {
          bloc.onChangeAddress(result);
          bloc.setLoading(false);
        },
      );
    }
  }

  void _onMapSelect() async {
    final result = await navigator.push(
      AddressFullScreenV2(
        address: widget.bloc.userAddress ?? AddressModel(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      // bloc.setLoading(true);

      // bloc.onSetAddress(result);
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          final locations = result["address"]["locations"].cast<double>();
          mController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  locations?[0] ?? 0,
                  locations?[1] ?? 0,
                ),
                zoom: 13.5,
              ),
            ),
          );
          EasyLoading.dismiss();
          // bloc.setLoading(false);
        },
      );
    }
  }
}

class AvatarCustom extends StatelessWidget {
  const AvatarCustom({
    super.key,
    required this.onTap,
    required this.path,
    required this.url,
    required this.size,
  });

  final void Function()? onTap;
  final String? path;
  final String? url;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: path == null
          ? CacheAvatarImage(
              width: size,
              height: size,
              borderRadius: size,
              url: url,
            )
          : CircleAvatar(
              radius: (size ?? 0) / 2,
              backgroundColor: AppColors.red,
              child: CircleAvatar(
                backgroundColor: AppColors.border_2,
                radius: size,
                backgroundImage: FileImage(File(path!)),
              ),
            ),
    );
  }
}
