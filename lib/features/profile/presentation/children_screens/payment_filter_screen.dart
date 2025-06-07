import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/core/extension/string_extension.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/widgets/base/base_loading.dart';
import 'package:bpg_retail/core/widgets/base/base_screen.dart';
import 'package:bpg_retail/core/widgets/base_container.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/profile/data/bloc/payment_history_cubit.dart';
import 'package:bpg_retail/features/profile/data/bloc/payment_history_state.dart';
import 'package:bpg_retail/features/profile/data/repositories/payment_repository.dart';

@RoutePage()
class PaymentFilterScreen extends StatefulWidget {
  const PaymentFilterScreen({
    super.key,
    required this.start,
    required this.end,
    required this.type,
    required this.wallet,
  });
  final String? start;
  final String? end;
  final int? type;
  final int? wallet;

  @override
  State<PaymentFilterScreen> createState() => _PaymentFilterScreenState();
}

final cubit = getIt.get<PaymentHistoryCubit>();

class _PaymentFilterScreenState extends State<PaymentFilterScreen> {
  @override
  void initState() {
    super.initState();
    endDate = TextEditingController(text: widget.end);
    starDate = TextEditingController(text: widget.start);
    cubit.initData(widget.type, widget.wallet);
  }

  TextEditingController? endDate;
  TextEditingController? starDate;
  final nav = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final defaultNow = DateFormat('y-MM-dd').format(now);
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      bloc: cubit,
      builder: (context, state) {
        if (state.isLoading) {
          return const BaseLoading();
        }
        return BaseScreen(
          title: "Bộ lọc",
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTimeFilter(context, defaultNow, now),
                16.height,
                _buildTransectionType(state),
                16.height,
                _buildWalletType(state),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ExtraButton(
                    radius: 30,
                    largeButton: false,
                    title: 'Huỷ bỏ',
                    onTap: () => nav.back(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ExtraButton(
                    radius: 30,
                    largeButton: false,
                    title: 'Áp dụng',
                    color: AppColors.white,
                    bgColor: AppColors.main,
                    borderColor: AppColors.main,
                    onTap: () {
                      nav.back(
                        result: FilterArgModel(
                          wallet: state.indexWallet,
                          transaction: state.indexTransaction,
                          end: endDate?.text,
                          start: starDate?.text,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BaseContainer _buildTransectionType(PaymentHistoryState state) {
    return BaseContainer(
      padding: 8.pading,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Loại giao dịch",
            style: s16w500,
          ),
          16.height,
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: cubit.transactionType.map(
              (e) {
                final isSelect = e.value == state.indexTransaction;
                return _item(
                  isSelect,
                  e.title,
                  () => cubit.selectTransaction(e.value),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _item(bool isSelect, String titile, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: BaseContainer(
        color: isSelect ? AppColors.main : AppColors.border_1,
        padding: 12.pading,
        child: Text(
          titile,
          style: s14w400.copyWith(
            color: isSelect ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  BaseContainer _buildWalletType(PaymentHistoryState state) {
    return BaseContainer(
      padding: 16.pading,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ví giao dịch",
            style: s16w500,
          ),
          16.height,
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: cubit.walletType.map(
              (e) {
                final isSelect = e.value == state.indexWallet;
                return _item(
                  isSelect,
                  e.title,
                  () => cubit.selectWallet(e.value),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(
    BuildContext context,
    String defaultNow,
    DateTime now,
  ) {
    return BaseContainer(
      padding: 16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Theo thời gian",
            style: s16w500,
          ),
          16.height,
          Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Từ ngày",
                      style: s16w500,
                    ),
                  ),
                  8.width,
                  const Expanded(
                    child: Text(
                      "Đến ngày",
                      style: s16w500,
                    ),
                  ),
                ],
              ),
              4.height,
              Row(
                children: [
                  Expanded(
                    child: ValidateTextField(
                      controller: starDate,
                      radius: 12,
                      initialValue: "",
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Chọn ngày',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      readOnly: true,
                      maxLines: 1,
                      onTap: () async {
                        final res = await showDatePicker(
                          // locale: const Locale('vi'),
                          context: context,
                          initialDate: DateFormat("y-MM-dd").parse(
                            (starDate?.text.nullOrEmpty == true
                                ? defaultNow
                                : starDate!.text),
                          ),
                          firstDate: DateTime(1900),
                          lastDate: now,
                        );
                        if (res is DateTime) {
                          starDate?.text = convertDateYYYYMMDD(
                            res,
                            isYYMMDD: true,
                          );
                        }
                      },
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 15,
                        bottom: 14,
                      ),
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: ValidateTextField(
                      radius: 12,
                      controller: endDate,
                      readOnly: true,
                      initialValue: "",
                      margin: EdgeInsets.zero,
                      backgroundColor: AppColors.white,
                      hintText: 'Chọn ngày',
                      hintStyle: AppTypography.p6.copyWith(
                        color: AppColors.grey_1,
                      ),
                      maxLines: 1,
                      onTap: () async {
                        final res = await showDatePicker(
                          // locale: const Locale('vi'),
                          context: context,
                          initialDate: DateFormat("y-MM-dd").parse(
                            (endDate?.text.nullOrEmpty == true
                                ? defaultNow
                                : endDate!.text),
                          ),
                          firstDate: DateTime(1900),
                          lastDate: now,
                        );
                        if (res is DateTime) {
                          endDate?.text = convertDateYYYYMMDD(
                            res,
                            isYYMMDD: true,
                          );
                        }
                      },
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 15,
                        bottom: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
