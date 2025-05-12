import 'package:auto_route/auto_route.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/extension/string_extension.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/converts.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/row_item.dart';
import 'package:BGP_Retail/core/widgets/textfield/validate_textfield.dart';
import 'package:BGP_Retail/features/cart/presentation/cart_qr_buy%20.dart';
import 'package:BGP_Retail/features/profile/data/bloc/payment_history_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/payment_history_state.dart';
import 'package:BGP_Retail/features/profile/data/repositories/payment_repository.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';

@RoutePage()
class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({
    super.key,
    this.code,
  });
  final String? code;

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

final nav = getIt.get<AppNavigator>();
final cubit = getIt.get<PaymentHistoryCubit>();

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  void initState() {
    super.initState();
    cubit.getPaymentDetail(widget.code ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
      bloc: cubit,
      builder: (context, state) {
        if (state.isLoading) {
          return const BaseLoading();
        }
        final detail = state.detail;
        return BaseScreen(
          title: "Chi tiết giao dịch",
          body: BaseContainer(
            padding: 16.pading,
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: AppColors.green65,
                        child: const Icon(
                          Icons.done_all,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "THANH TOÁN ĐƠN HÀNG",
                          style: s14w400,
                        ),
                        Text(
                          formatCurrency(detail?.amount ?? 0),
                          style: s24w700,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                RowCustom(
                  title: "Mã giao dịch:",
                  widget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(detail?.code ?? ""),
                      4.width,
                      GestureDetector(
                        onTap: () => copyToClipboard(detail?.code ?? ""),
                        child: const Icon(
                          Icons.copy,
                          size: 14,
                          color: AppColors.blue31,
                        ),
                      ),
                    ],
                  ),
                ),
                8.height,
                RowCustom(
                  title: "Mã tham chiếu:",
                  widget: (detail?.referenceOrderCode == null)
                      ? const Text("_")
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              detail?.referenceOrderCode ?? "_",
                              style: s14w400.copyWith(
                                color: AppColors.blue31,
                              ),
                            ),
                            4.width,
                            GestureDetector(
                              onTap: () => copyToClipboard(
                                detail?.referenceOrderCode ?? "",
                              ),
                              child: const Icon(
                                Icons.copy,
                                size: 14,
                                color: AppColors.blue31,
                              ),
                            ),
                          ],
                        ),
                ),
                8.height,
                RowCustom(
                  title: "Trạng thái:",
                  widget: BaseContainer(
                      padding: 4.pading,
                      color: AppColors.green_2,
                      borderColor: AppColors.green_2,
                      child: Text(
                        "Thành công",
                        style: s14w500.copyWith(color: AppColors.green65),
                      )),
                ),
                8.height,
                8.height,
                RowCustom(
                  title: "Ví giao dịch:",
                  widget: Text(detail?.wallet ?? ""),
                ),
                8.height,
                RowCustom(
                  title: "Thời gian giao dịch:",
                  widget: Text(convertDateFormatTime(detail?.createdAt ?? "")),
                ),
                8.height,
                RowCustom(
                  title: "Nội dung:",
                  widget: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Thanh toan đơn hàng",
                          style:
                              AppTypography.p6.copyWith(color: AppColors.black),
                        ),
                        TextSpan(
                          text: " #${detail?.code}",
                          style: AppTypography.p6
                              .copyWith(color: AppColors.blue31),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RowCustom extends StatelessWidget {
  const RowCustom({
    super.key,
    required this.title,
    required this.widget,
  });
  final String title;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: s14w400),
        12.width,
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: widget),
        ),
      ],
    );
  }
}
