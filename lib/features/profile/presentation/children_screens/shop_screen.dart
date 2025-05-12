import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/spacing_extension.dart';
import 'package:BGP_Retail/core/utilities/assets.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/row_item.dart';
import 'package:BGP_Retail/features/booth/data/models/asbc_both_v2_model.dart';
import 'package:BGP_Retail/features/cart/data/models/qr_order_detail_model.dart';

@RoutePage()
class ShopPage extends StatefulWidget {
  const ShopPage({super.key, this.data});
  final AbbcBothV2Model? data;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late GoogleMapController mController;

  @override
  void initState() {
    super.initState();
  }

  var kGooglePlex = const CameraPosition(
    target: LatLng(20.9984316, 105.7949591),
    zoom: 13.5,
  );

  @override
  Widget build(BuildContext context) {
    final addressData = widget.data?.warehouseData?.firstOrNull;

    return BaseScreen(
      title: "Thông tin shop",
      isImageBg: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: BaseContainer(
            padding: 16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseContainer(
                  borderColor: AppColors.white,
                  padding: 8.pading,
                  width: double.infinity,
                  color: getColorBackground(),
                  child: Center(
                    child: Text(
                      getStatus(),
                      style: s14w500.copyWith(
                        color: getTextColor(),
                      ),
                    ),
                  ),
                ),
                24.height,
                const Text("Thông tin shop", style: s16w500),
                16.height,
                RowItem(
                  title: "Tên shop:",
                  subtitle: widget.data?.title ?? "",
                  titleStyle: s16w400.copyWith(
                    color: AppColors.grey79,
                  ),
                  subStyle: s16w400,
                ),
                16.height,
                RowItem(
                  title: "Mã số thuế:",
                  subtitle: "-",
                  titleStyle: s16w400.copyWith(
                    color: AppColors.grey79,
                  ),
                  subStyle: s16w400,
                ),
                24.height,
                const Text("Thông tin kho hàng", style: s16w500),
                16.height,
                RowItem(
                  title: "Tên quản lý kho:",
                  subtitle: addressData?.manager ?? "-",
                  titleStyle: s16w400.copyWith(
                    color: AppColors.grey79,
                  ),
                  subStyle: s16w400,
                ),
                8.height,
                RowItem(
                  title: "Số điện thoại:",
                  subtitle: addressData?.phone ?? "",
                  titleStyle: s16w400.copyWith(
                    color: AppColors.grey79,
                  ),
                  subStyle: s16w400,
                ),
                8.height,
                RowItem(
                  title: "Địa chỉ kho:",
                  subtitle: addressData?.addressData?.addressFull ?? "",
                  titleStyle: s16w400.copyWith(
                    color: AppColors.grey79,
                  ),
                  subStyle: s16w400,
                  maxLines: 2,
                ),
                8.height,
                Container(
                  height: 134,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (controller) {
                          mController = controller;
                          mController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  (addressData?.addressData?.lat ?? 0)
                                      .toDouble(),
                                  (addressData?.addressData?.long ?? 0)
                                      .toDouble(),
                                ),
                                zoom: 13.5,
                              ),
                            ),
                          );
                        },
                        onTap: (argument) async {},
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: kGooglePlex,
                      ),
                      Center(
                        child: Assets.icon(
                          assetName: "ic_map_pin.svg",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? getColorBackground() {
    if (widget.data?.status == "active") {
      return AppColors.blue_2;
    }
    if (widget.data?.status == "inactive") {
      return AppColors.red_2;
    }
    if (widget.data?.status == "pending") {
      return AppColors.yellowFF;
    }

    return AppColors.yellowFF;
  }

  Color? getTextColor() {
    if (widget.data?.status == "active") {
      return AppColors.blue_1;
    }
    if (widget.data?.status == "inactive") {
      return AppColors.red_1;
    }
    if (widget.data?.status == "pending") {
      return AppColors.yellowD2;
    }

    return AppColors.yellowD2;
  }

  String getStatus() {
    // if (widget.data?.status == "active") {
    //   return "Đang hoạt động";
    // }
    // if (widget.data?.status == "inactive") {
    //   return "Dừng hoạt động";
    // }
    // if (widget.data?.status == "pending") {
    //   return "Chờ phê duyệt";
    // }

    return "Chờ phê duyệt";
  }
}
