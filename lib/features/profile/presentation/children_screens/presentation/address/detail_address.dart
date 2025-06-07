import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/core/base/base_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/address_state.dart';
import 'package:bpg_retail/features/profile/data/models/address_model.dart';
import 'package:bpg_retail/features/profile/presentation/children_screens/widgets/address/build_form_address.dart';
import 'package:flutter/material.dart';

@RoutePage(name: "DetailAddressPage")
class DetailAddressPage extends StatefulWidget {
  const DetailAddressPage({super.key, required this.address});

  final AddressModel address;

  @override
  State<DetailAddressPage> createState() => _DetailAddressPageState();
}

class _DetailAddressPageState
    extends BaseState<DetailAddressPage, AddressCubit> {
  List<double> latLong = [];
  @override
  void initState() {
    super.initState();
    latLong = bloc.onDetail(widget.address);
  }

  @override
  Widget buildPage(BuildContext context) {
    return BaseScaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            SizedBox(
              width: 38,
              height: 38,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chi tiết địa chỉ',
              style: AppTypography.h4,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: buildFormAddress(bloc),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: ExtraButton(
                    largeButton: false,
                    title: 'Huỷ bỏ',
                    onTap: () => navigator.back(),
                  ),
                ),
                if (bloc.isChangeEdit) const SizedBox(width: 10),
                if (bloc.isChangeEdit)
                  Expanded(
                    child: ExtraButton(
                      isLoading: state.isLoading,
                      largeButton: false,
                      title: 'Lưu lại',
                      color: AppColors.white,
                      bgColor: AppColors.main,
                      borderColor: AppColors.main,
                      onTap: () {},
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
