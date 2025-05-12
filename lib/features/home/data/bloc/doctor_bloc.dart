import 'package:BGP_Retail/features/booth/data/models/doctor_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/features/home/data/repositories/banner_repository.dart';

class DoctorBloc extends Cubit<CubitState> {
  DoctorBloc() : super(CubitState());
  final BannerRepository _repo = BannerRepository();
  List<DoctorModel> list = [];
  void getDoctors() async {
    // categories.clear();
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _repo.getDoctors();
    if (res.data != null) {
      // list.addAll(res.data!);
      list = res.data ?? [];
    }

    emit(state.copyWith(status: CubitStatus.success));
  }
}
