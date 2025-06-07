import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/utilities/assets.dart';
import 'package:bpg_retail/core/utilities/screens.dart';
import 'package:bpg_retail/core/widgets/base/appbar.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_state.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

class AddressFullScreen extends StatefulWidget {
  const AddressFullScreen({super.key, required this.address});

  final AddressModel address;

  @override
  State<AddressFullScreen> createState() => _AddressFullScreenState();
}

class _AddressFullScreenState
    extends BaseState<AddressFullScreen, AddressCubit> {
  List<double> latLogNew = [0, 0];

  @override
  void initState() {
    final latLog = bloc.onDetail(widget.address);
    setState(() {
      latLogNew = latLog;
    });
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return BaseScaffold(
      backgroundImage: false,
      paddingTopAppBar: true,
      appBar: const BaseAppBar(
        title: "Thêm địa chỉ",
      ),
      body: Container(
        height: heightDevice(context),
        color: AppColors.white,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              List<double> latLog = [0, 0];
              final AddressModel? address = state.address;
              if (latLogNew.any((e) => e != 0)) {
                latLog = latLogNew;
              } else if (address != null &&
                  address.locations != null &&
                  address.locations!.length == 2) {
                latLog = address.locations!;
              } else {
                latLog = [20.937341, 106.314554];
              }
              const temp = 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
              return latLog.any((e) => e != 0)
                  ? FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          latLog[0],
                          latLog[1],
                        ),
                        initialZoom: 13.5,
                        onPointerDown: (pos, llg) {},
                        onPositionChanged: (mapPosition, isBool) {
                          final llg = mapPosition.bounds!.center;
                          setState(() {
                            latLogNew = [llg.latitude, llg.longitude];
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: temp,
                          userAgentPackageName: 'com.lhe.bpg_retail',
                          subdomains: const [
                            'mt0',
                            'mt1',
                            'mt2',
                            'mt3',
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              rotate: true,
                              point: LatLng(
                                latLog[0],
                                latLog[1],
                              ),
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [
                                  Text(
                                    "Vị trí của bạn",
                                    style: AppTypography.p5.copyWith(
                                      shadows: <Shadow>[
                                        const Shadow(
                                          offset: Offset(
                                            0.0,
                                            0.0,
                                          ),
                                          blurRadius: 6.0,
                                          color: Color.fromARGB(
                                            255,
                                            235,
                                            251,
                                            255,
                                          ),
                                        ),
                                        const Shadow(
                                          offset: Offset(
                                            0.0,
                                            0.0,
                                          ),
                                          blurRadius: 6.0,
                                          color: Color.fromARGB(
                                            255,
                                            235,
                                            251,
                                            255,
                                          ),
                                        ),
                                        const Shadow(
                                          offset: Offset(
                                            0.0,
                                            0.0,
                                          ),
                                          blurRadius: 6.0,
                                          color: Color.fromARGB(
                                            255,
                                            235,
                                            251,
                                            255,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Assets.icon(
                                    assetName: "ic_map_pin.svg",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const BaseLoading();
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
                title: 'Lưu lại',
                color: AppColors.white,
                bgColor: AppColors.main,
                borderColor: AppColors.main,
                onTap: () async {
                  if (latLogNew.length < 2) {
                    latLogNew = [20.937341, 106.314554];
                  }
                  if (latLogNew.any((e) => e == 0)) {
                    navigator.pop();
                  } else {
                    final result = await bloc.updateLatLong(latLogNew);
                    if (result != null) {
                      navigator.pop(result: result.toJson());
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
