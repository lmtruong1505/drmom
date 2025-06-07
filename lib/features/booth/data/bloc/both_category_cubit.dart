import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:bpg_retail/features/booth/data/repositories/booth_repository.dart';

@Injectable()
class BothCategoryCubit extends Cubit<CubitState> {
  final BoothRepository _boothRepository;
  List<DropdownButtonModel>? listCategory;
  DropdownButtonModel? category;

  BothCategoryCubit(this._boothRepository) : super(CubitState());
  void getBothCategory(int id) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final res = await _boothRepository.getBothCategory(id);
    if (res.code == 200) {
      if (res.data?.isNotEmpty == true) {
        listCategory = res.data!
            .map((e) => DropdownButtonModel(label: e.title ?? '', value: e.id))
            .toList();
      }

      emit(state.copyWith(status: CubitStatus.success));
    } else {
      emit(state.copyWith(status: CubitStatus.loaded));
    }
  }

  void selectCategory(DropdownButtonModel? value) {
    category = value;
    emit(state.copyWith(status: CubitStatus.success));
  }
}
