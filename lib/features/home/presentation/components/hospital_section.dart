import 'package:BGP_Retail/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/utilities/funtion.dart';
import 'package:BGP_Retail/features/booth/data/bloc/asbc_both_cubit.dart';
import 'package:BGP_Retail/features/booth/data/bloc/asbc_both_state.dart';
import 'package:BGP_Retail/features/booth/data/models/asbc_both_model.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

class HospitalSection extends StatefulWidget {
  const HospitalSection({super.key, required this.bloc});
  final AsbcBothCubit bloc;

  @override
  State<HospitalSection> createState() => _HospitalSectionState();
}

class _HospitalSectionState extends State<HospitalSection> {
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    return BlocBuilder<AsbcBothCubit, AsbcBothState>(
      bloc: bloc,
      builder: (context, state) {
        final listBoth = state.listBoths;
        if (listBoth?.isEmpty == true) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bệnh viện",
                  style: s16w700,
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Text(
                //     'Xem tất cả',
                //     style: s14w500.copyWith(
                //       color: AppColors.main,
                //     ),
                //   ),
                // ),
              ],
            ),
            12.height,
            Container(
              height: 96,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                separatorBuilder: (context, index) => 16.width,
                itemCount: listBoth?.length ?? 0,
                itemBuilder: (context, index) {
                  final both = listBoth?[index];
                  return BaseContainer(
                    borderRadius: 12,
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: CacheNetworkImageWidget(
                            borderRadius: 0,
                            url: both?.image ?? '',
                            width: 96,
                            height: 96,
                          ),
                        ),
                        12.width,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                both?.name ?? '',
                                style: s12w700,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                both?.address ?? '',
                                style: s12w400,
                              ),
                            ),
                          ],
                        ).expanded(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ).padding(16.padingLeft);
      },
    );
  }
}
