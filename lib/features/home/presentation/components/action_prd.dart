import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bpg_retail/app/data/bloc/app_cubit.dart';
import 'package:bpg_retail/app/routes/router.gr.dart';
import 'package:bpg_retail/core/base/cubit_state.dart';
import 'package:bpg_retail/core/constants/colors.dart';
import 'package:bpg_retail/core/injection/injection.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_bloc.dart';
import 'package:bpg_retail/features/cart/data/bloc/cart_bloc_V2.dart';

class ActionPrd extends StatelessWidget {
  ActionPrd({super.key});

  final cartBloc = getIt.get<CartV2Bloc>();

  @override
  Widget build(BuildContext context) {
    final isLogin = context.watch<AppCubit>().state.isLoggedIn;

    return Row(
      children: [
        // Badge.count(
        //   count: context.watch<PrdFavoriteBloc>().prds.length,
        //   isLabelVisible:
        //       context.watch<PrdFavoriteBloc>().prds.isNotEmpty && isLogin,
        //   child: BtnIcon(
        //     onTap: () {
        //       if (isLogin) {
        //         context.pushRoute(const FavoriteRoute());
        //       } else {
        //         context.pushRoute(LoginPage());
        //       }
        //     },
        //     size: const Size(45, 45),
        //     radius: 45,
        //     icon: const Icon(
        //       Icons.favorite_border,
        //       color: AppColors.main,
        //     ),
        //   ),
        // ),
        // // BtnIcon(
        // //   onTap: () => context.pushRoute(const FavoriteRoute()),
        // //   size: const Size(45, 45),
        // //   radius: 45,
        // //   icon: const Icon(
        // //     Icons.favorite_border,
        // //     color: AppColors.main,
        // //   ),
        // // ),
        // 12.width,

        BlocBuilder<CartV2Bloc, CubitState>(
          bloc: cartBloc,
          builder: (context, state) {
            return Badge.count(
              count: cartBloc.cartLength,
              isLabelVisible: cartBloc.cartLength > 0 && isLogin,
              child: GestureDetector(
                onTap: () {
                  if (isLogin) {
                    context.pushRoute(const CartPrdRouteV2());
                  } else {
                    context.pushRoute(const LoginRoute());
                  }
                },
                // size: const Size(45, 45),
                // radius: 45,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.grey79,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
