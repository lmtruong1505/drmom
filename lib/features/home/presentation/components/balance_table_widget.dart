import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/localization_helper.dart';
import 'package:bpg_retail/features/home/data/bloc/transection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bpg_retail/core/core.dart';

class BalanceTable extends StatelessWidget {
  final TransactionBloc bloc;

  const BalanceTable({super.key, required this.bloc});
  @override
  Widget build(BuildContext context) {
    final closeBalance =
        (bloc.metaData?.openBalance ?? 0) - bloc.listCustom.length;
    final trans = AppLocalizations.of(context);
    return Table(
      border: TableBorder.all(
        color: AppColors.bg_6,
        borderRadius: 8.radius,
      ), // Thêm viền cho toàn bộ bảng
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(
            color: AppColors.greyE2,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          children: [
            _buildHeaderCell(trans.translate('opening_balance')),
            _buildHeaderCell(trans.translate('hire')),
            _buildHeaderCell(trans.translate('dehire')),
            _buildHeaderCell(trans.translate('closing_balance')),
          ],
        ),
        // Data row
        TableRow(
          children: [
            _buildDataCell(formatNumberV2(bloc.metaData?.openBalance ?? 0)),
            _buildDataCell(formatNumberV2(bloc.totalHIRE)),
            _buildDataCell(formatNumberV2(bloc.totalDEHIRE)),
            _buildDataCell(formatNumberV2(closeBalance)),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: 8.pading,
      child: Text(
        text,
        style: s12w400.copyWith(color: AppColors.grey79),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: 8.pading,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: s12w400.copyWith(color: AppColors.main),
      ),
    );
  }
}
