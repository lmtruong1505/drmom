import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/utilities/debouncer.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_state.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:location/location.dart';

@RoutePage()
class AddressFullScreenV2 extends StatefulWidget {
  const AddressFullScreenV2({super.key, required this.address});

  final AddressModel address;

  @override
  State<AddressFullScreenV2> createState() => _AddressFullScreenV2State();
}

class _AddressFullScreenV2State
    extends BaseState<AddressFullScreenV2, AddressCubit> {
  List<double> latLogNew = [0, 0];
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  void getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled == false) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled == false) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void goToLocation(double? lat, double? long) async {
    final mLocation = CameraPosition(
      target: LatLng(lat ?? 0, long ?? 0),
      zoom: 13,
    );
    await _controller?.animateCamera(CameraUpdate.newCameraPosition(mLocation));
  }

  void getMLocation() async {
    _locationData = await location.getLocation();
    goToLocation(_locationData?.latitude, _locationData?.longitude);
  }

  // List<double>? latLog;

  @override
  void initState() {
    latLogNew = bloc.onDetail(widget.address);
    // setState(() {
    //   latLogNew = latLog;
    // });
    super.initState();
    getPermission();
    if (widget.address.address != null) {
      final locations = widget.address.address["locations"];
      _kGooglePlex = CameraPosition(
        target: LatLng(
          locations?[0] ?? 0,
          locations?[1] ?? 0,
        ),
        zoom: 13,
      );
    } else {
      _kGooglePlex = CameraPosition(
        target: LatLng(
          preferences.locations[0],
          preferences.locations[1],
        ),
        zoom: 13,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  GoogleMapController? _controller;
  final _debouncer = Debouncer();

  late final CameraPosition _kGooglePlex;

  @override
  Widget buildPage(BuildContext context) {
    return BaseScaffold(
      paddingTop: false,
      backgroundImage: false,
      paddingTopAppBar: false,
      appBar: const BaseAppBar(
        title: "Thêm địa chỉ",
      ),
      body: Container(
        color: AppColors.white,
        height: heightDevice(context),
        width: double.infinity,
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            // List<double> latLog = [0, 0];
            // final AddressModel? address = state.address;
            // if (latLogNew.any((e) => e != 0)) {
            //   latLog = latLogNew;
            // } else if (address != null &&
            //     address.locations != null &&
            //     address.locations!.length == 2) {
            //   latLog = address.locations!;
            // } else {
            //   latLog = [20.937341, 106.314554];
            // }
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (controller) {
                    _controller = controller;
                    // goToLocation(latLogNew[0], latLogNew[1]);
                  },
                  onCameraIdle: () {},
                  onCameraMove: (CameraPosition position) {
                    // print(widget.address.locations?[0]);
                    // if (position.target.latitude !=
                    //     widget.address.locations?[0]) {
                    _debouncer.run(() {
                      print("Get new position");
                      final newPosition = position.target;
                      latLogNew[0] = newPosition.latitude;
                      latLogNew[1] = newPosition.longitude;
                      // bloc.updateLatLong(latLogNew);
                    });
                    // }
                  },
                ),
                Center(child: Assets.icon(assetName: "ic_map_pin.svg")),
              ],
            );
          },
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
            const SizedBox(width: 10),
            Expanded(
              child: ExtraButton(
                largeButton: false,
                title: 'Lưu lại',
                color: AppColors.white,
                bgColor: AppColors.main,
                borderColor: AppColors.main,
                onTap: () async {
                  // if (latLogNew.length < 2) {
                  //   latLogNew = [20.937341, 106.314554];
                  // }
                  if (latLogNew.any((e) => e == 0)) {
                    navigator.pop();
                  } else {
                    final result = await bloc.updateLatLong(latLogNew);
                    if (result != null) {
                      navigator.pop<Map<String, dynamic>>(
                        result: result.toJson(),
                      );
                    }
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
