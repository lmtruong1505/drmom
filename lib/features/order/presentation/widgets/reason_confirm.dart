import 'package:flutter/material.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/constants/spacing.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/core/navigation/navigator.dart';
import 'package:bpg_retail/core/utilities/converts.dart';
import 'package:bpg_retail/core/utilities/enum.dart';
import 'package:bpg_retail/core/widgets/base/scaffold.dart';
import 'package:bpg_retail/core/widgets/buttons/extra_button.dart';
import 'package:bpg_retail/core/widgets/textfield/validate_textfield.dart';
import 'package:bpg_retail/features/order/data/models/order_asbc_model.dart';
import 'package:bpg_retail/features/order/data/models/order_model.dart';
import 'package:bpg_retail/gen/assets.gen.dart';

class ReasonConfirm extends StatefulWidget {
  const ReasonConfirm({
    super.key,
    required this.reasons,
    required this.title,
    this.type = OrderEnum.CANCEL,
    this.order,
  });

  final List<DataModel> reasons;
  final OrderEnum? type;
  final String title;
  final OrderModel? order;

  @override
  State<ReasonConfirm> createState() => _ReasonConfirmState();
}

class _ReasonConfirmState extends State<ReasonConfirm> {
  // int? checkedValue;
  // String reasonValue = '';
  DataModel? reasonSelected;
  // @override
  // void didUpdateWidget(covariant ReasonConfirm oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    final inputReasonId = widget.reasons.lastOrNull?.id;
    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      paddingTop: true,
      backgroundImage: false,
      paddingTopAppBar: true,
      body: Padding(
        padding: Spacing.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: AppTypography.h5,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    navigator.pop();
                  },
                  child: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            if (widget.type == OrderEnum.CANCEL) ...[
              Align(
                alignment: Alignment.center,
                child: Assets.images.boxError.image(),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: Spacing.a20,
                decoration: BoxDecoration(
                  color: AppColors.yellow_2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Assets.icons.icWarningCircle.svg(),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Text(
                        widget.type == OrderEnum.CANCEL
                            ? "Vui lòng chọn lý do."
                            : 'Chúng tôi rất tiếc khi đem lại những trải nghiệm không tốt cho bạn. Vui lòng mô tả tình trạng bạn đang gặp phải:',
                        style: AppTypography.p5.copyWith(
                          color: AppColors.yellow_1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (['RETURN', 'RETURN_VIEW'].contains(widget.type?.code))
              const Text(
                "Chúng tôi rất tiếc khi đem lại những trải nghiệm không tốt cho bạn.",
              ),
            if (['RETURN_VIEW'].contains(widget.type?.code)) ...[
              const SizedBox(height: 24),
              Text(
                widget.order!.reason ?? '',
              ),
              const SizedBox(height: 16),
              Text(
                convertDateFormatTime(
                  widget.order!.reasonDate!,
                ),
                style: AppTypography.p5.copyWith(
                  color: AppColors.grey_1,
                ),
              ),
            ],
            if (widget.type == OrderEnum.RETURN) ...[
              const SizedBox(height: 24),
              const Text(
                "Tình trạng bạn đang gặp phải",
                style: AppTypography.h6,
              ),
              const SizedBox(height: 8),
            ],
            if (!widget.type!.code!.contains('VIEW'))
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.reasons.length,
                  itemBuilder: (context, index) {
                    final reason = widget.reasons[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reasonSelected = reason;
                              // checkedValue = reason.id;
                              // reasonValue = reason.title ?? "";
                            });
                          },
                          child: Transform.translate(
                            offset: const Offset(-14, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: reason,
                                  groupValue: reasonSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      reasonSelected = reason;
                                    });
                                  },
                                  activeColor: AppColors.main,
                                ),
                                Flexible(
                                  child: Text(
                                    reason.title ?? "",
                                    style: AppTypography.p5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (reasonSelected?.id == inputReasonId &&
                            index == (widget.reasons.length - 1))
                          ValidateTextField(
                            initialValue: "",
                            margin: EdgeInsets.zero,
                            backgroundColor: AppColors.white,
                            hintText: 'Nhập lý do khác tại đây',
                            hintStyle: AppTypography.p6.copyWith(
                              color: AppColors.grey_1,
                            ),
                            maxLines: 4,
                            onChanged: (value) {
                              // setState(() {
                              reasonSelected =
                                  reasonSelected?.copyWith(title: value);
                              // });
                            },
                            validator: (value) {
                              return null;
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.type!.code!.contains('VIEW'))
              Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      largeButton: true,
                      title: 'Huỷ bỏ',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      onTap: () {
                        navigator.pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ExtraButton(
                      largeButton: true,
                      title: 'Xác nhận',
                      borderColor: AppColors.main,
                      color: AppColors.white,
                      bgColor: AppColors.main,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      onTap: () {
                        navigator.pop(result: reasonSelected);
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ReasonResult {
  final bool result;
  final DataModel? reason;

  ReasonResult({required this.result, this.reason});
}
