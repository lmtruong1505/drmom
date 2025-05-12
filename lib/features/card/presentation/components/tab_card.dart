import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:BGP_Retail/core/base/cubit_state.dart';
import 'package:BGP_Retail/core/extension/init_ext.dart';
import 'package:BGP_Retail/core/utilities/enum.dart';
import 'package:BGP_Retail/core/widgets/base/base_loading.dart';
import 'package:BGP_Retail/features/card/presentation/components/card_item.dart';

import '../../data/cubits/card_bloc.dart';

class TabCard extends StatefulWidget {
  const TabCard({super.key});

  @override
  State<TabCard> createState() => _TabCardState();
}

class _TabCardState extends State<TabCard> with AutomaticKeepAliveClientMixin {
  final bloc = CardBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getCards();
    scroll.onMore(() => bloc.getCards(isMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getCards();
      },
      child: BlocBuilder<CardBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == CubitStatus.loading && bloc.cards.isEmpty) {
            return const Center(child: BaseLoading());
          }
          return SingleChildScrollView(
            controller: scroll,
            padding: 16.pading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => CardItem(
                    model: bloc.cards[index],
                  ),
                  separatorBuilder: (context, index) => 16.height,
                  itemCount: bloc.cards.length,
                ),
                Center(
                  child: state.status == CubitStatus.loading &&
                          bloc.cards.isNotEmpty
                      ? const BaseLoading()
                      : null,
                ).size(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
