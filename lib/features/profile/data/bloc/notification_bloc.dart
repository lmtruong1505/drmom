import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:BGP_Retail/core/base/base_cubit.dart';
import 'package:BGP_Retail/core/env/env.dart';
import 'package:BGP_Retail/core/utilities/debouncer.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/profile/data/bloc/notification_state.dart';
import 'package:BGP_Retail/features/profile/data/models/notification_model.dart';
import 'package:BGP_Retail/features/profile/data/repositories/noti_repository.dart';

@Injectable()
class NotificationCubit extends BaseCubit<NotificationState> {
  NotificationCubit(this._notiRepository) : super(const NotificationState());
  final NotiRepository _notiRepository;

  String? search;
  @override
  void initState() {
    initEnv();
    getListNotiFromAPI();

    super.initState();
  }

  String url = "test";
  List<NotificationModel> listNotiDB = [];
  List<NotificationModel> listNotiDBLoadmore = [];
  bool isMore = false;

  void initEnv() {
    const env = EnvironmentConfig.ENV;
    if (env == "prod") {
      url = "prod";
    } else {
      url = "test";
    }
  }

  int get totalUnSeen {
    final total = state.notifyListFB.where((e) => !e.status!).toList().length +
        state.notifyListDB.where((e) => !e.status!).toList().length;
    return total;
  }

  List<int> get listNotiSelected {
    return state.notifyListDB
        .where((element) => (element.isChecked == true))
        .map((e) => e.id ?? 0)
        .toList();
  }

  // Hiển thi ra dropdown filter theo module thông báo
  void onFilter() {
    emit(state.copyWith(isFilter: !state.isFilter));
  }

  // Hiển thị các checkbox để chọn xoá hàng loạt
  void openDeleteMany() {
    emit(state.copyWith(isDeleteMany: !state.isDeleteMany));
    if (!state.isDeleteMany) {
      emit(state.copyWith(isChecked: false));
    }
  }

  // Xoá nhiều noti
  void deleteMany() {
    onDeleteNoti(listNotiDB: listNotiSelected);
  }

  // Xoá 1 noti
  void deleteOne(int? id, String? key) {
    if (id != null) {
      onDeleteNoti(listNotiDB: [id]);
    }
    //  else if (key != null) {
    //   onDeleteNoti(listNotiFB: [key]);
    // }
  }

  // Thực hiện xoá noti
  void onDeleteNoti({List<String>? listNotiFB, List<int>? listNotiDB}) async {
    try {
      // if (listNotiFB != null) {
      //   appCubit.setCallNoti(false);
      //   // ignore: avoid_function_literals_in_foreach_calls
      //   listNotiFB.forEach((element) async {
      //     final ref = FirebaseDatabase.instance
      //         .ref('noti_$url/${preferences.currentUser.user!.id}/$element');
      //     await ref.remove();
      //   });
      //   openDeleteMany();
      // }
      if (listNotiDB != null) {
        final res = await _notiRepository
            .deleteNoti({"list_notifi": listNotiDB, "system": "TMDT"});
        if (res.code == 200) {
          final newList = List<NotificationModel>.from(state.notifyListDB);
          for (final id in listNotiDB) {
            newList.removeWhere((element) => element.id == id);
          }

          // .removeAt((e) {
          //   for (var i = 0; i < listNotiDB.length; i++) {
          //     if (e.id == listNotiDB[i]) {
          //       e = e.copyWith(status: true);
          //     }
          //   }
          //   return e;
          // }).toList();
          emit(state.copyWith(notifyListDB: newList));
          showOverlayToast(title: "Xoá tin nhắn thành công");
        }
        // return res;
      }
      // if (listNotiDB != null) {
      //   isLoading.value = true;
      //   Map<String, dynamic> payload = {
      //     "list_notifi": listNotiDB,
      //     "user_id": appController.profileId,
      //     "system": 'MAIN',
      //   };
      //   final res = await _notiApi.deleteNotification(payload);
      //   infiniteListController.onRefresh();
      //   isLoading.value = false;
      //   return res;
      // }
      // return {"code": 200};
    } catch (e) {
      print(e);
    }
  }

  // Đánh dấu đã đọc tất cả noti
  Future<void> markAsSeenAll() async {
    onMarkAsSeen(listNotiDB: state.lstNotiUnread);
  }

  // Đánh dấu đã đọc 1 noti
  Future<void> markAsSeen(int? id, String? key) async {
    if (id != null) {
      onMarkAsSeen(listNotiDB: [id]);
    }
    //  else if (key != null) {
    //   onMarkAsSeen(listNotiFB: [key]);
    // }
  }

  // thực hiện đọc noti
  void onMarkAsSeen({
    List<String>? listNotiFB,
    List<int>? listNotiDB,
  }) async {
    try {
      // appCubit.setCallNoti(false);
      // final userId = preferences.currentUser.user!.id;
      // if (listNotiFB != null) {
      //   listNotiFB.forEach((element) async {
      //     final ref =
      //         FirebaseDatabase.instance.ref('noti_$url/$userId/$element');
      //     await ref.update({'status': true});
      //   });
      // }
      if (listNotiDB != null) {
        emit(state.copyWith(status: CubitStatus.loading));
        final res = await _notiRepository.seenNoti({"list_notifi": listNotiDB});
        emit(state.copyWith(status: CubitStatus.success));
        if (res.code == 200) {
          final newList = state.notifyListDB.map((e) {
            for (var i = 0; i < listNotiDB.length; i++) {
              if (e.id == listNotiDB[i]) {
                e = e.copyWith(status: true);
              }
            }
            return e;
          }).toList();
          emit(state.copyWith(notifyListDB: newList, totalUnread: 0));
        }
        // return res;
      }
      // final listNofiFB = appCubit.state.notifyList
      //     .map((e) => e.copyWith(status: true))
      //     .toList();
      // appCubit.state = appCubit.state.copyWith(notifyList: listNotiFB);
      // infiniteListController.onRefresh();
      // return {"code": 200};
    } catch (e) {
      emit(state.copyWith(status: CubitStatus.loaded));
      // print('Noti error');
      // return {};
    }
  }

  void updateReadedNoti(
    List<int>? listNotiDB,
  ) async {
    if (listNotiDB != null) {
      final newList = List<NotificationModel>.from(state.notifyListDB).map((e) {
        for (var i = 0; i < listNotiDB.length; i++) {
          if (e.id == listNotiDB[i]) {
            e = e.copyWith(status: true);
          }
        }
        return e;
      }).toList();
      emit(state.copyWith(notifyListDB: newList));
    }
  }

  void onNotificationType(String notificationType) {
    emit(state.copyWith(notificationType: notificationType));
  }

  void onChecked(bool? isChecked) {
    emit(state.copyWith(isChecked: isChecked!));
    openDeleteMany();
    onCheckedAllNotification();
  }

  // Filter status
  void onChangeFilter(int? status) {
    if (status != state.filter) {
      // emit(state.copyWith(isChecked: false));
      // onCheckedAllNotification();
    }
    emit(state.copyWith(filter: status, notifyListDB: []));
    page = 0;
    getListNotiFromAPI();
  }

  void onCheckedItem(int id) {
    final notifies = List<NotificationModel>.from(state.notifyListDB).map((e) {
      if (e.id == id) {
        e = e.copyWith(isChecked: !(e.isChecked ?? false));
      }
      return e;
    }).toList();

    final readLength = notifies.where((e) => e.status == true).length;
    final readCheckedLength =
        notifies.where((e) => e.status == true && (e.isChecked == true)).length;

    emit(
      state.copyWith(
        notifyListDB: notifies,
        isChecked: readLength == readCheckedLength,
      ),
    );
  }

  void onCheckedAllNotification() {
    final notifies = state.notifyListDB.map((e) {
      if (e.status == true) {
        e = e.copyWith(isChecked: state.isChecked);
      }
      return e;
    }).toList();
    emit(state.copyWith(notifyListDB: notifies));
  }

  int page = 0;
  // Lấy danh sách các noti từ Database
  void getListNotiFromAPI() async {
    if (page == 0) {
      emit(state.copyWith(isLoading: true));
    }
    emit(state.copyWith(status: CubitStatus.loading));

    final Map<String, dynamic> payload = {
      "page": page,
      "page_size": 10,
      "id": preferences.currentUser.user?.id ?? 0,
      "system": "TMDT",
      "status": state.filter,
    };
    final res = await _notiRepository.getListNoti(payload);

    emit(state.copyWith(isLoading: false));

    res.fold(
      (l) {
        navigator.showErrorSnackBar(l["message"] ?? 'Có lỗi xảy ra!');
        emit(state.copyWith(status: CubitStatus.error));
      },
      (r) {
        final data = r["data"];
        final result = data["results"] as List;
        if (result.length == 10) {
          isMore = true;
        } else {
          isMore = false;
        }
        final lst = result.map((e) => NotificationModel.fromJson(e)).toList();

        final newListNofiFB = state.notifyListDB + lst;
        final isChecked = newListNofiFB.length ==
            newListNofiFB.where((element) => element.isChecked == true).length;
        emit(
          state.copyWith(
            status: CubitStatus.success,
            notifyListDB: state.notifyListDB + lst,
            lstNotiReaded: data["seen_list"].cast<int>(),
            lstNotiUnread: data["unseen_list"].cast<int>(),
            totalReaded: data["total_seen"],
            totalUnread: data["total_unseen"],
            isChecked: isChecked,
          ),
        );
      },
    );

    // mergeListNoti();
  }

  void onLoadMoreNoti() {
    page++;
    getListNotiFromAPI();
  }

  void onRefreshNoti() {
    page = 0;
    emit(state.copyWith(notifyListDB: []));
    // appCubit.getNotiFromFirebase(isLoginCallNotify: false);
    getListNotiFromAPI();
  }

  // Nối danh sách lấy từ FB và danh sách lấy từ DB lại
  // void mergeListNoti() {
  //   final listNofiFB = appCubit.state.notifyList;
  //   // if (page == 0) {
  //   emit(
  //     state.copyWith(
  //       notifyListFB: listNofiFB,
  //       notifyListDB: state.notifyListDB + listNotiDBLoadmore,
  //     ),
  //   );
  //   // } else {
  //   //   emit(state.copyWith(notifyList: state.notifyList + listNotiDBLoadmore));
  //   // }
  // }

// Tạo thông báo
  void createNoti({
    required List<int> listUser,
    List<int>? listUserTMDT,
    required Map<String, dynamic> dataNotify,
  }) {
    try {
      for (final element in listUser) {
        final ref = FirebaseDatabase.instance.ref('noti_$url/$element');

        final Map<String, dynamic> data = dataNotify;
        data.removeWhere((key, value) {
          return value == null;
        });
        data['created_at'] = '${DateTime.now()}';
        data["user"] = element;
        data["system"] = "MAIN";
        ref.push().set(data);
      }

      for (final element in listUserTMDT ?? []) {
        final ref = FirebaseDatabase.instance.ref('noti_$url/$element');

        final Map<String, dynamic> data = dataNotify;
        data.removeWhere((key, value) {
          return value == null;
        });
        data['created_at'] = '${DateTime.now()}';
        data["user"] = element;
        data["system"] = "TMDT";
        ref.push().set(data);
      }
    } catch (e) {
      print(e);
    }
  }

  final _debounce = Debouncer();

  void onSearch(String value) {
    _debounce.run(() {
      search = value;
      getListNotiFromAPI();
    });
  }
}
