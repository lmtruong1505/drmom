import 'package:auto_route/auto_route.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/booth/data/models/transection_detail_model.dart';
import 'package:bpg_retail/features/home/data/bloc/galary_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class GalleryPage extends StatefulWidget {
  final TransactionItem items;
  final int initialIndex;

  const GalleryPage({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    bloc.onChangePage(widget.initialIndex);
  }

  final bloc = GalaryBloc();

  @override
  Widget build(BuildContext context) {
    final imgs = widget.items.product?.images;
    final trans = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            trans.translate('detail'),
            style: s16w500.copyWith(color: AppColors.white),
          ),
          leading: const CloseButton(color: AppColors.white),
        ),
        body: BlocBuilder<GalaryBloc, CubitState>(
          builder: (context, state) {
            final selectPage = bloc.selectPage ?? 0;
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PhotoView(
                        imageProvider:
                            NetworkImage(imgs?[selectPage].image ?? ''),
                        backgroundDecoration:
                            const BoxDecoration(color: AppColors.black),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: AppColors.black.withOpacity(0.2),
                          child: Row(
                            children: [
                              Text(
                                widget.items.product?.description ?? '',
                                maxLines: bloc.seeMore ? 1 : null,
                                overflow: TextOverflow.ellipsis,
                                style: s16w400.copyWith(color: AppColors.white),
                              ).expanded(),
                              GestureDetector(
                                onTap: () => bloc.onChangeSeeMore(),
                                child: Text(
                                  bloc.seeMore
                                      ? trans.translate('see_more')
                                      : trans.translate('hide'),
                                  style:
                                      s14w400.copyWith(color: AppColors.greyAA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: 12.padingVer,
                  child: CarouselSlider.builder(
                    itemCount: imgs?.length,
                    options: CarouselOptions(
                      height: 80,
                      initialPage: widget.initialIndex,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.2,
                      onPageChanged: (index, reason) {
                        bloc.onChangePage(index);
                      },
                    ),
                    itemBuilder: (ctx, i, real) {
                      return GestureDetector(
                        onTap: () => bloc.onChangePage(i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: i == selectPage
                                  ? AppColors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: 8.radius,
                          ),
                          child: CacheNetworkImageV2(
                            width: 60,
                            height: 60,
                            url: imgs?[i].image ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
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
