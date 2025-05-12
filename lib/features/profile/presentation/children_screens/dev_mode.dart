import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/configs/logger.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/widgets/appbar_back_button.dart';
import 'package:BGP_Retail/core/widgets/base/base_screen.dart';
import 'package:BGP_Retail/core/widgets/base/scaffold.dart';

@RoutePage()
class DevModeScreen extends StatefulWidget {
  const DevModeScreen({super.key});

  @override
  State<DevModeScreen> createState() => _DevModeScreenState();
}

class _DevModeScreenState extends State<DevModeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "DevModeScreen",
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final log = apiLogs[index];
            return ListTile(
              title: Text(
                log.url,
                style: s14w500,
              ),
              subtitle: Text(
                log.response.toString(),
                style: s14w400.copyWith(
                  color: AppColors.bg_3,
                ),
              ),
              onTap: () {},
            );
          },
          separatorBuilder: (context, index) {
            return 16.height;
          },
          itemCount: apiLogs.length),
    );
  }
}
