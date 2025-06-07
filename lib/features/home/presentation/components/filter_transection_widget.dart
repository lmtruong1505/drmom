import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/home/data/bloc/transection_bloc.dart';
import 'package:bpg_retail/features/home/presentation/components/transaction_home_tab.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterTransactionWidget extends StatelessWidget {
  FilterTransactionWidget({
    super.key,
    required this.bloc,
  });

  final TransactionBloc bloc;
  final navigator = getIt<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DropdownButtonWidget(
              value: bloc.filterSelect,
              hintText: trans.translate('select'),
              items: bloc.listFilter
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        trans.translate(e.name),
                        maxLines: 2,
                        style: s14w400,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p0) {
                bloc.filterWarehouse(p0);
              },
              text: trans.translate(bloc.filterSelect?.name ?? ''),
            ).expanded(),
            12.width,
            DropdownButtonWidget(
              maxHeightDropdown: 400,
              value: bloc.warehouse,
              hintText: trans.translate('select_warehouse'),
              items: bloc.listWarehouse
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name ?? '',
                        maxLines: 2,
                        style: s14w400,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p0) {
                bloc.selectWareHouse(p0);
              },
              text: bloc.warehouse?.name,
            ).expanded(),
            12.width,
            BtnIcon(
              hasData: bloc.range?.endDate != null,
              borderColor: AppColors.grey79,
              onTap: () {
                context.dialog(
                  child: Dialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    backgroundColor: AppColors.white,
                    insetPadding: 16.pading,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SfDateRangePickerCustom(
                          minDate: bloc.datePeriodSelect?.openingDate,
                          maxDate: bloc.datePeriodSelect?.closingDate,
                          onSubmit: (p0) {
                            if (p0 is DateTime) {
                              bloc.selectEndDate(p0);
                            }
                            navigator.pop();
                          },
                          selectionMode: DateRangePickerSelectionMode.single,
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.grey79,
              ),
              size: const Size(48, 48),
            ),
          ],
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
        8.height,
        Text(
          '${trans.translate('viewing')} ${bloc.selectedEndDate.toTextDefaulft}',
          style: s14w400.copyWith(color: AppColors.grey79),
          textAlign: TextAlign.start,
        ),
        8.height,
        Visibility(
          visible: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (bloc.range is PickerDateRange)
                DateRangWidget(
                  start: bloc.range!.startDate.toTextDefaulft,
                  end: bloc.range!.endDate.toTextDefaulft,
                ),
              Text(
                '${trans.translate('viewing')} ${bloc.range?.endDate.toTextDefaulft}',
                style: s14w400.copyWith(color: AppColors.grey79),
              ),
            ],
          ).padding(16.padingVer),
        ),
      ],
    );
  }
}

class SfDateRangePickerCustom extends StatelessWidget {
  SfDateRangePickerCustom({
    super.key,
    this.onSubmit,
    this.initialSelectedRange,
    this.initialSelectedDate,
    this.selectionMode = DateRangePickerSelectionMode.range,
    this.minDate,
    this.maxDate,
  });
  final PickerDateRange? initialSelectedRange;
  final DateTime? initialSelectedDate;
  final DateRangePickerSelectionMode selectionMode;
  final DateTime? minDate;
  final DateTime? maxDate;
  final navigator = getIt<AppNavigator>();
  final Function(Object?)? onSubmit;
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context);
    return SfDateRangePicker(
      initialSelectedDate: initialSelectedDate,
      initialSelectedRange: initialSelectedRange,
      monthViewSettings:
          const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
      todayHighlightColor: AppColors.main,
      startRangeSelectionColor: AppColors.main,
      endRangeSelectionColor: AppColors.main,
      rangeSelectionColor: AppColors.main.withOpacity(0.3),
      selectionShape: DateRangePickerSelectionShape.rectangle,
      showActionButtons: true,
      cancelText: trans.translate('close'),
      confirmText: trans.translate('confirm'),
      onSubmit: onSubmit,
      minDate: minDate,
      maxDate: maxDate,

      onCancel: () {
        navigator.pop();
      },

      // initialSelectedRange: bloc.range,
      view: DateRangePickerView.month,
      selectionMode: selectionMode,
    );
  }
}
