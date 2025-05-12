import 'package:auto_route/auto_route.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:BGP_Retail/app/routes/router.gr.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/injection/injection.dart';
import 'package:BGP_Retail/core/navigation/navigator.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/utilities/loading.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/buttons/main_button.dart';
import 'package:BGP_Retail/core/widgets/textfield/pin_input_textfield.dart';
import 'package:BGP_Retail/core/widgets/toast/overlay_custom.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_cubit.dart';
import 'package:BGP_Retail/features/profile/data/bloc/deposit_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangeTokenBankScreen extends StatefulWidget {
  const ChangeTokenBankScreen({super.key});

  @override
  State<ChangeTokenBankScreen> createState() => _ChangeTokenBankScreenState();
}

class _ChangeTokenBankScreenState extends State<ChangeTokenBankScreen> {
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    // bloc.getListMyBank();
  }

  final bloc = getIt.get<DepositWithdrawCubit>();
  final navigator = getIt.get<AppNavigator>();
  late TextEditingController _ctrl;
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepositWithdrawCubit, DepositWithdrawState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == CubitStatus.success) {
          EasyLoading.dismiss();
          navigator.push(OtpVerificationTokenRoute(token: state.token ?? ""));
        } else if (state.status == CubitStatus.loaded) {
          showOverlayToast(
            title: state.message ?? "",
            iconColor: AppColors.red_1,
          );
          EasyLoading.dismiss();
        } else if (state.status == CubitStatus.loading) {
          showLoading();
        }
      },
      child: BaseScreen(
        padding: 16,
        title: "Mã pin",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nhập mã mới để thay đổi mã pin của bạn"),
            8.height,
            Form(
              key: key,
              child: PinInputField(
                ctrl: _ctrl,
                validator: (p0) {
                  if (((p0?.length ?? 0) < 6) == true) {
                    return "Mã pin gồm 6 chữ số";
                  }
                  return null;
                },
              ),
            ),
            16.height,
            Container(
              width: double.infinity,
              child: MainButton(
                icon: const Icon(
                  Icons.add,
                  color: AppColors.main,
                ),
                largeButton: true,
                title: "Xác nhận",
                onTap: () async {
                  if (!key.currentState!.validate()) {
                    return;
                  }
                  bloc.sendRequestChangeToken(_ctrl.text);
                },
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
