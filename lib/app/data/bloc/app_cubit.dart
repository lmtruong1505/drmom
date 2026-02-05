import 'dart:async';
import 'package:bpg_retail/core/core.dart';
import 'package:bpg_retail/app/data/bloc/app_state.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/base_cubit.dart';
import 'package:bpg_retail/core/utilities/loading.dart';
import 'package:bpg_retail/core/widgets/address_selection/bloc/address_selection_cubit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/features/booth/data/models/booth_model.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';

@LazySingleton()
class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(const AppState());

  // pub_location.Location location = pub_location.Location();

  final preferences = getIt.get<Preferences>();
  final navigator = getIt.get<AppNavigator>();
  // ProfileModel? get currentAvatar {
  //   return preferences.currentUser.user!.profiles!.firstWhere(
  //     (e) => e.field == 'avatar',
  //     orElse: () => ProfileModel(),
  //   );
  // }

  @override
  void initState() async {
    if (preferences.accessToken != null) {
      setLoading(true);

      // setCartData();
      onAppInitialized();
      // getNotiFromFirebase(isLoginCallNotify: false);

      // final homeCubit = getIt.get<HomeCubit>();
      // final results = await homeCubit.getHomeFormula();

      // emit(state.copyWith(formulas: results.formulas));
      setLoading(false);
      getProvinces();
    }
    super.initState();
  }

  void getProvinces() async {
    final addressSelectionCubit = getIt.get<AddressSelectionCubit>();
    final provinces = await addressSelectionCubit.getProvinces();
    setProvinces(provinces);
  }

  // void setCartData() {
  //   final carts = preferences.carts;
  //   final cartCheckedLength = carts.where((e) => e.isChecked == true).length;
  //   emit(
  //     state.copyWith(
  //       isChecked: carts.isNotEmpty && cartCheckedLength == carts.length,
  //       cartList: carts,
  //     ),
  //   );
  // }

  void setProvinces(List<dynamic> provinces) {
    emit(state.copyWith(provinces: provinces));
  }

  // void setCart(FormulaModel formula, {CartModel? cartItem}) {
  //   final List<CartModel> carts =
  //       state.cartList.map((e) => e.copyWith()).toList();

  //   final index = carts.indexWhere(
  //     (e) => e.formula.formulaId == formula.formulaId,
  //   );
  //   if (index == -1) {
  //     carts.add(
  //       CartModel(
  //         priceFormulaId: cartItem != null
  //             ? cartItem.priceFormulaId
  //             : formula.unitPrice![0].priceFormulaId,
  //         isChecked: false,
  //         formula: formula,
  //         quantity: cartItem != null ? cartItem.quantity : 1,
  //         price:
  //             cartItem != null ? cartItem.price : formula.unitPrice![0].price,
  //       ),
  //     );
  //   } else {
  //     carts[index] = carts[index].copyWith(
  //       quantity: cartItem != null
  //           ? carts[index].quantity + cartItem.quantity
  //           : carts[index].quantity + 1,
  //       priceFormulaId: cartItem != null
  //           ? cartItem.priceFormulaId
  //           : carts[index].priceFormulaId,
  //     );
  //   }
  //   preferences.saveCarts(jsonEncode(carts));
  //   emit(
  //     state.copyWith(
  //       cartList: carts
  //           .map(
  //             (e) => e.copyWith(isChecked: false),
  //           )
  //           .toList(),
  //       isChecked: false,
  //     ),
  //   );
  //   if (cartItem != null) {
  //     navigator.pop();
  //   }
  //   navigator.showSuccessSnackBar(
  //     "+${cartItem == null ? 1 : cartItem.quantity} ${formula.formulaName}",
  //     duration: const Duration(seconds: 1),
  //   );
  // }

  // void changeCart(
  //   FormulaModel formula, {
  //   bool? isChecked,
  //   int? quantity,
  //   int? priceFormulaId,
  //   double? price,
  // }) {
  //   final List<CartModel> carts = state.cartList
  //       .map(
  //         (e) => e.copyWith(),
  //       )
  //       .toList();

  //   final index = carts.indexWhere(
  //     (e) => e.formula.formulaId == formula.formulaId,
  //   );
  //   if (index != -1) {
  //     carts[index] = carts[index].copyWith(
  //       priceFormulaId: priceFormulaId ?? carts[index].priceFormulaId,
  //       isChecked: isChecked ?? carts[index].isChecked,
  //       quantity: quantity ?? carts[index].quantity,
  //       price: price ?? carts[index].price,
  //     );
  //   }

  //   preferences.saveCarts(jsonEncode(carts));
  //   final isC = carts.where((e) => e.isChecked).length == state.cartList.length;
  //   emit(
  //     state.copyWith(
  //       cartList: carts,
  //       isChecked: isC,
  //     ),
  //   );
  // }

  // void setCheckedAllCart(bool isChecked) {
  //   emit(
  //     state.copyWith(
  //       isChecked: isChecked,
  //       cartList: state.cartList
  //           .map(
  //             (e) => e.copyWith(isChecked: isChecked),
  //           )
  //           .toList(),
  //     ),
  //   );
  //   preferences.saveCarts(jsonEncode(state.cartList));
  // }

  // void removeCart(FormulaModel formula) {
  //   final List<CartModel> carts = state.cartList
  //       .map(
  //         (e) => e.copyWith(),
  //       )
  //       .toList();

  //   final index = carts.indexWhere(
  //     (e) => e.formula.formulaId == formula.formulaId,
  //   );
  //   if (index != -1) {
  //     carts.removeAt(index);
  //   }
  //   preferences.saveCarts(jsonEncode(carts));
  //   emit(state.copyWith(cartList: carts));
  //   navigator.showSuccessSnackBar(
  //     "Đã xóa ${formula.formulaName}",
  //     duration: const Duration(seconds: 1),
  //   );
  // }

  // void upgradeCart(List<CartModel> cartList) {
  //   preferences.saveCarts(jsonEncode(cartList));
  //   emit(state.copyWith(isChecked: false, cartList: cartList));
  // }

  void setBooth(List<BoothModel> booths) {
    emit(
      state.copyWith(booths: booths),
    );
  }

  void setAddressList(List<AddressModel> addressList) {
    emit(state.copyWith(addressList: addressList));
  }

  void setBoothSelected(BoothModel booth) {
    emit(state.copyWith(boothSelected: booth));
  }

  // void setFormula(List<FormulaModel> formulas) {
  //   emit(state.copyWith(formulas: formulas));
  // }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setLoadingAddress(bool isLoadingAddress) {
    emit(state.copyWith(isLoadingAddress: isLoadingAddress));
  }

  // void setOrderChange(OrderModel? orderChange) {
  //   emit(state.copyWith(orderChange: orderChange));
  // }

  // Future<void> checkLocationPermission() async {
  //   emit(state.copyWith(serviceEnabled: await location.serviceEnabled()));
  //   if (!state.serviceEnabled) {
  //     emit(state.copyWith(serviceEnabled: await location.requestService()));
  //     if (!state.serviceEnabled) {
  //       return;
  //     }
  //   }

  //   emit(
  //     state.copyWith(permissionGranted: await location.hasPermission()),
  //   );
  //   if (state.permissionGranted == pub_location.PermissionStatus.denied) {
  //     emit(
  //       state.copyWith(permissionGranted: await location.requestPermission()),
  //     );
  //     if (state.permissionGranted != pub_location.PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   // getCurrentLocation();
  // }

  // void getCurrentLocation() async {
  //   try {
  //     // final LocationData currentLocation = await location.getLocation();
  //     final Position currentLocation = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     final latitude = currentLocation.latitude;
  //     final longitude = currentLocation.longitude;
  //     final prefLocation = preferences.locations;
  //     final ok = prefLocation.length > 1;
  //     if (ok && (prefLocation[0] != latitude || prefLocation[1] != longitude)) {
  //       setBooth([]);
  //     }
  //     preferences.saveLocation(
  //       jsonEncode([
  //         currentLocation.latitude,
  //         currentLocation.longitude,
  //       ]),
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Failed to get the location: $e");
  //     }
  //   }
  // }

  // void onChangeAvatar(String avatar) {
  //   emit(state.copyWith(avatar: avatar));
  // }

  // Future<void> onIsLoggedIn(bool isLoggedIn) async {
  //   emit(state.copyWith(isLoggedIn: isLoggedIn));
  // }

  void onAppInitialized() {
    if (preferences.accessToken != null) {
      emit(
        state.copyWith(
          isLoggedIn: true,
        ),
      );
    } else {
      emit(state.copyWith(isLoggedIn: false));
      emit(state.copyWith(avatar: null));
    }
  }

  FutureOr onForceLogout({bool? isMessage = true}) async {
    try {
      showLoading();
      // await preferences.removeCurrentUser();
      EasyLoading.dismiss();
      // onAppInitialized();
      if (isMessage == true) {
        navigator.showSuccessSnackBar(
          'Đăng xuất thành công',
          duration: const Duration(seconds: 1),
        );
        navigator.replaceAll([const LoginRoute()]);
      }
      // emit(
      //   state.copyWith(
      //     notifyList: [],
      //     callNoti: false,
      //     booths: [],
      //     boothSelected: null,
      //     addressList: [],
      //   ),
      // );
      navigator.replaceAll([const LoginRoute()]);
      // navigator.popUntilRoot();
    } catch (e) {
      print(e);
      navigator.replaceAll([const LoginRoute()]);
      EasyLoading.dismiss();
    }
  }

  // bool onFormulaFavorite(FormulaModel formula) {
  //   final List<FormulaModel> productFavorite = preferences.productFavorite;

  //   final index = productFavorite.indexWhere(
  //     (e) => e.formulaId == formula.formulaId,
  //   );

  //   bool isFavorite = false;

  //   if (index != -1) {
  //     productFavorite.removeAt(index);
  //     isFavorite = false;
  //   } else {
  //     productFavorite.add(formula);
  //     isFavorite = true;
  //   }

  //   preferences.saveProductFavorite(jsonEncode(productFavorite));
  //   return isFavorite;
  // }

  // bool onBoothFavorite(BoothModel booth) {
  //   final List<BoothModel> boothFavorite = preferences.boothFavorite;

  //   final index = boothFavorite.indexWhere(
  //     (e) => e.id == booth.id,
  //   );

  //   bool isFavorite = false;

  //   if (index != -1) {
  //     boothFavorite.removeAt(index);
  //     isFavorite = false;
  //   } else {
  //     boothFavorite.add(booth);
  //     isFavorite = true;
  //   }

  //   preferences.saveBoothFavorite(jsonEncode(boothFavorite));
  //   return isFavorite;
  // }

  // UserModel? get currentUser {
  //   return preferences.currentUser.user;
  // }

  void setCustomId(String customId) {
    emit(state.copyWith(customId: customId));
  }

  // void setCallNoti(bool value) {
  //   emit(state.copyWith(callNoti: value));
  // }

  // void onMarkAsSeen(String? key) async {
  //   if (key == null) return;
  //   try {
  //     setCallNoti(false);
  //     final ref = FirebaseDatabase.instance.ref(
  //       'noti_prod/${preferences.currentUser.user!.id}/$key',
  //     );
  //     await ref.update({'status': true});
  //   } on FirebaseException {}
  // }

  // Future<void> getNotiFromFirebase({bool? isLoginCallNotify = true}) async {
  //   if (!state.isLoggedIn || currentUser == null) return;
  //   try {
  //     emit(state.copyWith(callNoti: isLoginCallNotify!));
  //     var listNotiStore = <NotificationModel>[];
  //     var notiStore = NotificationModel(isChecked: false);
  //     final ref = FirebaseDatabase.instance.ref(
  //       'noti_test/${preferences.currentUser.user!.id}',
  //     );
  //     ref.onValue.listen(
  //       (DatabaseEvent event) {
  //         if (!state.isLoggedIn || currentUser == null) {
  //           emit(state.copyWith(callNoti: false));
  //         } else {
  //           final listNotiLoad = <NotificationModel>[];
  //           final DataSnapshot dataSnapshot = event.snapshot;
  //           if (dataSnapshot.exists) {
  //             final Map<dynamic, dynamic> values = dataSnapshot.value as Map;

  //             if (values.isNotEmpty) {
  //               values.forEach((key, value) {
  //                 final Map<String, dynamic> notiMap =
  //                     value.cast<String, dynamic>();
  //                 notiMap['isChecked'] = false;
  //                 if (notiMap['custom_id'] != null) {
  //                   notiMap['custom_id'] = notiMap['custom_id'].toString();
  //                 }
  //                 if (notiMap['module'] == 'TM_ORDER') {
  //                   listNotiLoad.add(
  //                     NotificationModel.fromJson(notiMap).copyWith(key: key),
  //                   );
  //                 }
  //                 // appCubit.getNotiFromFirebase(isLoginCallNotify: false);
  //               });

  //               listNotiStore = listNotiLoad.map((e) => e.copyWith()).toList();
  //               listNotiStore.sort(
  //                 (a, b) => DateTime.parse(b.createdAt!)
  //                     .compareTo(DateTime.parse(a.createdAt!)),
  //               );
  //               emit(state.copyWith(notifyList: listNotiStore));

  //               // mỗi lần có thông báo mới thì show toast
  //               if (isLoginCallNotify == true &&
  //                   state.callNoti &&
  //                   listNotiStore.isNotEmpty) {
  //                 notiStore = listNotiStore.first;

  //                 if (notiStore.user != preferences.currentUser.user!.id) {
  //                   return;
  //                 }

  //                 showOverlayNotification(
  //                   (context) {
  //                     return SafeArea(
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           onMarkAsSeen(notiStore.key);
  //                           OverlaySupportEntry.of(context)?.dismiss();
  //                           // navigator
  //                           //     .push(OrderDetailPage(id: notiStore.customId));
  //                         },
  //                         child: Card(
  //                           child: ListTile(
  //                             leading: SizedBox.fromSize(
  //                               size: const Size(40, 40),
  //                               // child: const Icon(
  //                               //   Icons.shopping_bag,
  //                               //   color: AppColors.main,
  //                               // ),
  //                               child: SvgPicture.string(
  //                                 notiStore.getImage(),
  //                               ),
  //                             ),
  //                             title: Text(
  //                               notiStore.title ?? 'Thông tin từ đơn hàng',
  //                             ),
  //                             subtitle: Text(notiStore.content ?? ''),
  //                             contentPadding: const EdgeInsets.symmetric(
  //                               vertical: 14,
  //                               horizontal: 16,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   duration: const Duration(milliseconds: 2000),
  //                 );

  //                 // navigator.showToast(
  //                 //   notiStore.title ?? '',
  //                 //   toastBorderRadius: 8.0,
  //                 //   backgroundColor: AppColors.green_2,
  //                 //   border: Border.all(
  //                 //     width: 1,
  //                 //     color: AppColors.green_1,
  //                 //   ),
  //                 //   textStyle: AppTypography.p5,
  //                 //   toastDuration: 5,
  //                 //   trailing: Center(
  //                 //     child: Assets.icon(
  //                 //       assetName: "ic_shopping_bag.svg",
  //                 //       width: 16,
  //                 //       height: 16,
  //                 //       colorFilter: ColorFilter.mode(
  //                 //         notiStore.isFailed == true
  //                 //             ? AppColors.red_1
  //                 //             : AppColors.blue_1,
  //                 //         BlendMode.srcIn,
  //                 //       ),
  //                 //     ),
  //                 //   ),
  //                 // );
  //               }
  //             } else {
  //               emit(state.copyWith(notifyList: []));
  //             }
  //           } else {
  //             emit(state.copyWith(notifyList: []));
  //           }
  //           emit(state.copyWith(callNoti: true));
  //         }
  //       },
  //       onError: (err) {
  //         if (kDebugMode) {
  //           print('==========Noti error: $err');
  //         }
  //         emit(state.copyWith(callNoti: true));
  //       },
  //     );
  //   } on FirebaseException {
  //     print('==============Noti error');

  //     emit(state.copyWith(callNoti: true));
  //   }
  // }
}
