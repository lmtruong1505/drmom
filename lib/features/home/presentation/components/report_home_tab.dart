import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/home/data/bloc/report_home_bloc.dart';
import 'package:bpg_retail/features/home/data/model/home_report_model.dart';
import 'package:bpg_retail/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportHomeTab extends StatefulWidget {
  const ReportHomeTab({
    super.key,
    required this.bloc,
  });
  final HomeReportBloc bloc;

  @override
  State<ReportHomeTab> createState() => _ReportHomeTabState();
}

class _ReportHomeTabState extends State<ReportHomeTab>
    with AutomaticKeepAliveClientMixin {
  final navigator = getIt<AppNavigator>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trans = AppLocalizations.of(context);
    final bloc = widget.bloc;
    return BlocBuilder<HomeReportBloc, CubitState>(
      builder: (context, state) {
        return Column(
          children: [
            12.height,
            DropdownButtonWidget(
              maxHeightDropdown: 300,
              value: bloc.warehouse,
              hintText: trans.translate('select'),
              items: bloc.listWarehouse
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name ?? '',
                        style: s14w400,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p0) {
                bloc.selectWareHouse(p0);
              },
              text: bloc.warehouse?.name,
            ),
            12.height,
            DropdownButtonWidget(
              value: bloc.datePeriodSelect,
              hintText: trans.translate('select_date'),
              items: bloc.listDatePeriod
                  ?.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        '${e.openingDate.toTextDefaulft}-${e.closingDate.toTextDefaulft}',
                        maxLines: 2,
                        style: s14w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p0) {
                bloc.filterDatePeriod(p0);
              },
              text:
                  '${bloc.datePeriodSelect?.openingDate.toTextDefaulft}-${bloc.datePeriodSelect?.closingDate.toTextDefaulft}',
            ),
            // if (bloc.range != null) ...[
            //   16.height,
            //   Text(
            //     '${start.toTextDefaulft} - ${end.toTextDefaulft}',
            //   ),
            // ],
            TitleDivider(
              title: trans.translate('warehouse_list'),
            ),
            state.status == CubitStatus.loading
                ? const BaseLoading()
                : WarehouseTable(
                    data: bloc.list,
                  ).expanded(),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Sinh list các ngày từ start đến end
List<DateTime>? daysInRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) {
    return null;
  }
  final days = <DateTime>[];
  for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
    days.add(d);
  }
  return days;
}

class TextRichCustom extends StatelessWidget {
  const TextRichCustom({
    super.key,
    this.title,
    this.data,
    this.titleStyle,
    this.dataStyle,
  });
  final String? title;
  final String? data;
  final TextStyle? titleStyle;
  final TextStyle? dataStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: titleStyle ?? s12w400.copyWith(color: AppColors.greyAA),
        children: [
          TextSpan(
            text: data,
            style: dataStyle ?? s14w400.copyWith(color: AppColors.main),
          ),
        ],
      ),
    );
  }
}

class WarehouseTable extends StatefulWidget {
  final List<ReportHomeModel> data;

  const WarehouseTable({
    required this.data,
    super.key,
  });

  @override
  State<WarehouseTable> createState() => _WarehouseTableState();
}

class _WarehouseTableState extends State<WarehouseTable> {
  final navigator = getIt<AppNavigator>();
  late ScrollController verticalScroll;
  late ScrollController horizontalScroll;
  @override
  void initState() {
    super.initState();
    verticalScroll = ScrollController();
    horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    verticalScroll.dispose();
    horizontalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);

    if (widget.data.isEmpty) {
      return EmptyWidget(title: trans.translate('empty_report'));
    }

    final detailKeys = widget.data.first.details?.keys.toList();

    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: verticalScroll,
      child: SingleChildScrollView(
        controller: verticalScroll,
        physics: const BouncingScrollPhysics(),
        child: Scrollbar(
          controller: horizontalScroll,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            controller: horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildHeaderCell(trans.translate('warehouse'), width: 150),
                    for (final key in detailKeys ?? []) _buildHeaderCell(key),
                  ],
                ),
                ...List.generate(
                  widget.data.length,
                  (index) {
                    final row = widget.data[index];

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyAA,
                        ),
                      ),
                      child: Row(
                        children: [
                          _headerColum(row),
                          for (final key in detailKeys ?? [])
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                showDetailDialog(row, index, key, trans);
                              },
                              child: _buildCell(
                                stock: row.details?[key]?.stock,
                                totalPrice: row.details?[key]?.totalPrice,
                                price: row.details?[key]?.price,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowInfor(String title, String data) {
    return Row(
      children: [
        Text(
          title,
          style: s10w400.copyWith(color: AppColors.grey79),
        ),
        const Spacer(),
        Text(
          data,
          style: s12w400.copyWith(color: AppColors.main),
        ),
      ],
    );
  }

  Widget _headerColum(ReportHomeModel row) {
    final trans = AppLocalizations.of(context);
    return Container(
      padding: 8.padingLeft,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.greyAA),
          left: BorderSide(width: 0, color: AppColors.white),
          top: BorderSide(width: 0, color: AppColors.white),
          bottom: BorderSide(width: 0, color: AppColors.white),
        ),
      ),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.warehouse ?? '',
            style: s12w500,
          ),
          _textCustom(
            '${trans.translate('invoice')}: ',
            formatCurrency(row.invoice),
          ),
          _textCustom(
            '${trans.translate('stock')}: ',
            formatNumberV2(row.actualBalance),
          ),
          _textCustom(
            '${trans.translate('opening_balance')}:',
            formatNumberV2(row.openBalance),
          ),
        ],
      ),
    );
  }

  Widget _textCustom(String title, String data) {
    return Text.rich(
      maxLines: 1,
      TextSpan(
        text: title,
        style: s10w400.copyWith(color: AppColors.greyAA),
        children: [
          TextSpan(
            text: data,
            style: s10w500.copyWith(color: AppColors.main),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {double width = 130}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      color: AppColors.main,
      child: Text(text, style: s14w400.copyWith(color: AppColors.white)),
    );
  }

  Widget _buildCell({
    double width = 130,
    num? stock,
    num? price,
    num? totalPrice,
  }) {
    return Container(
      width: width,
      padding: 8.pading,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatNumberV2(stock),
            style: s12w500,
          ),
          Text(
            formatCurrency(totalPrice),
            style: s10w400.copyWith(color: AppColors.greyAA),
          ),
          Text(
            formatCurrency(price),
            style: s10w400.copyWith(color: AppColors.greyAA),
          ),
        ],
      ),
    );
  }

  void showDetailDialog(
    ReportHomeModel row,
    int index,
    dynamic key,
    AppLocalizations trans,
  ) {
    final detail = row.details?[key];
    final now = DateTime.now();
    final today = now.add(Duration(days: index));
    context.dialog(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: 16.radius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  today.toTextDefaulft,
                  style: s16w500,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => navigator.pop(),
                  child: const Icon(
                    Icons.cancel,
                    size: 20,
                    color: AppColors.greyE2,
                  ),
                ),
              ],
            ),
            const Divider(),
            Visibility(
              visible: detail?.productData != null,
              child: Row(
                children: [
                  CacheNetworkImageV2(
                    width: 56,
                    height: 56,
                    borderRadius: 8,
                    url: detail?.productData?.productFile?.imageData,
                    fit: BoxFit.contain,
                  ),
                  12.width,
                  Column(
                    children: [
                      Text(
                        detail?.productData?.productName ?? '',
                        style: s12w400,
                      ),
                      Text(
                        detail?.productData?.productCode ?? '',
                        style: s10w400.copyWith(
                          color: AppColors.grey79,
                        ),
                      ),
                    ],
                  ).expanded(),
                  Text(
                    'x ${formatNumberV2(detail?.stock)}',
                    style: s10w400.copyWith(
                      color: AppColors.grey79,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              row.warehouse ?? '',
              style: s14w500,
              textAlign: TextAlign.left,
            ),
            _rowInfor(
              trans.translate('stock'),
              formatNumberV2(
                detail?.stock,
              ),
            ),
            _rowInfor(
              '${trans.translate('bill_of')} ${today.toTextDefaulft}',
              formatNumberV2(
                detail?.price,
              ),
            ),
            _rowInfor(
              '${trans.translate('total_bill_from')}  ${now.toTextDefaulft} ${trans.translate('to')} ${today.toTextDefaulft}',
              formatNumberV2(
                detail?.totalPrice,
              ),
            ),
            16.height,
            Align(
              alignment: Alignment.center,
              child: MainButton(
                title: trans.translate('close'),
                onTap: () => navigator.pop(),
              ),
            ),
          ],
        ).padding(16.pading),
      ),
    );
  }
}
