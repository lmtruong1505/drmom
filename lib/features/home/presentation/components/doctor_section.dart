import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/core.dart';
import 'package:BGP_Retail/features/home/data/bloc/doctor_bloc.dart';

class DoctorSection extends StatelessWidget {
  const DoctorSection({
    super.key,
    required this.bloc,
  });

  final DoctorBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.list.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bác sĩ",
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
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                separatorBuilder: (context, index) => 16.width,
                itemCount: bloc.list.length,
                itemBuilder: (context, index) {
                  final doctor = bloc.list[index];
                  return BaseContainer(
                    borderRadius: 8,
                    width: 128,
                    height: 170,
                    child: Stack(
                      children: [
                        CacheNetworkImageWidget(
                          borderRadius: 6,
                          url: doctor.avatar,
                          width: 128,
                          height: 170,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 8,
                          right: 8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  doctor.fullName ?? '',
                                  style: s12w700,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Text(', '),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: doctor.departments?.length ?? 0,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Text(
                                    doctor.departments?[index].name ?? '',
                                    style: s12w400.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ).padding(16.padingLeft + 24.padingTop);
      },
    );
  }
}
