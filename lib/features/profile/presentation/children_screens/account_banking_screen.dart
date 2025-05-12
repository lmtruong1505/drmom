import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base_container.dart';
import 'package:BGP_Retail/core/widgets/buttons/extra_button.dart';
import 'package:BGP_Retail/core/widgets/cache_image_network_widget.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/features/profile/data/models/bank_model.dart';

@RoutePage()
class AccountBankScreen extends StatefulWidget {
  const AccountBankScreen({super.key});

  @override
  State<AccountBankScreen> createState() => _AccountBankScreenState();
}

class _AccountBankScreenState extends State<AccountBankScreen> {
  @override
  void initState() {
    super.initState();

    bloc.getListMyBank();
  }

  final bloc = getIt.get<DepositWithdrawCubit>();
  final navigator = getIt.get<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepositWithdrawCubit, DepositWithdrawState>(
      bloc: bloc,
      builder: (context, state) {
        return BaseScreen(
          padding: 16,
          title: "Tài khoản ngân hàng",
          body: RefreshIndicator(
            onRefresh: () async {
              bloc.getListMyBank();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: ExtraButton(
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.main,
                    ),
                    borderColor: AppColors.main,
                    color: AppColors.main,
                    largeButton: true,
                    title: "Thêm tài khoản ngân hàng",
                    onTap: () async {
                      final result =
                          await navigator.push(CreateAccountBankScreen());

                      if (result == true) {
                        bloc.getListMyBank();
                      }
                    },
                  ),
                ),
                16.height,
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = state.listMyBank?[index];
                      return _bankItem(item);
                    },
                    separatorBuilder: (context, index) => 8.height,
                    itemCount: state.listMyBank?.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bankItem(MyBankModel? item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result =
            await navigator.push(CreateAccountBankScreen(id: item?.id));
        if (result is bool && result == true) {
          bloc.getListMyBank();
        }
      },
      child: BaseContainer(
        padding: 16.pading,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(
                    "Ngân hàng ",
                    item?.bankData?.shortName ?? "",
                  ),
                  8.height,
                  Text(
                    (item?.accountName ?? '_').toUpperCase(),
                    style: s14w400,
                  ),
                  8.height,
                  Text(
                    item?.accountNumber ?? "",
                    style: s14w400,
                  ),
                  8.width,
                  Visibility(
                    visible: item?.isDefault ?? false,
                    child: BaseContainer(
                      padding: 4.pading,
                      color: AppColors.green65,
                      child: Text(
                        "Mặc định",
                        style: s12w400.copyWith(color: AppColors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            CacheNetworkImageWidget(
              url: item?.bankData?.logo,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String descripsion) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: s12w400),
        Text(
          descripsion,
          style: s12w500,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###", "vi");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') return newValue;

    // Xóa dấu phân cách hiện tại và format lại
    final String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final String formattedText = _formatter
        .format(int.parse(newText))
        .replaceAll('.', ' '); // Thay dấu ',' bằng dấu cách

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
