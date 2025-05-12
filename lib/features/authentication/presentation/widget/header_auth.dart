import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';

class HeaderAuthForm extends StatelessWidget {
  const HeaderAuthForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        paddingTop.height,
        80.height,
        // Assets.images.logo.image(
        //   width: 56,
        //   height: 56,
        // ),
      ],
    );
  }
}
