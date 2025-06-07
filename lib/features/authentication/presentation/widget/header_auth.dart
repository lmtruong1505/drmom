import 'package:bpg_retail/core/extension/init_ext.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';

class HeaderAuthForm extends StatelessWidget {
  const HeaderAuthForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).viewPadding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        paddingTop.height,
        190.height,
        Assets.images.logo.image(
          width: 198,
          height: 100,
        ),
      ],
    );
  }
}
