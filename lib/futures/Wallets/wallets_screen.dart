import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moteelz/core/extensions/async_value_u_i.dart';
import 'package:moteelz/core/extensions/navigation_extension.dart';
import 'package:moteelz/futures/Wallets/widget/custom_search_app_bar.dart';
import 'package:moteelz/futures/Wallets/widget/filter_wallet_widget.dart';
import 'package:moteelz/futures/Wallets/state/Wallets_state.dart';
import '../../routes/route_manager.dart';
import 'state/Wallets_notifier.dart';
import 'state/Wallets_provider.dart';
import 'widget/wallet_card.dart';

class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletsNotifierProvider);
    final notifier = ref.read(walletsNotifierProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          extendedPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          backgroundColor: Theme.of(context).primaryColor,
          label: Text(
            'التصفية',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
          icon: Icon(Icons.storage_outlined, color: Colors.white),
          onPressed: () async {
            _showFilterWalletWidget(context, ref, state);
          }),
      appBar: CustomSearchAppBar(
        onSearchChanged: (value) {
          notifier.applyFilter(WalletFilter(name: value));
        },
      ),
      body: RefreshIndicator.adaptive(
        child: _buildBody(state, notifier),
        onRefresh: () {
          return notifier.applyFilter(state.filter);
        },
      ),
    );
  }

  Widget _buildBody(WalletsState state, WalletsNotifier notifier) {
    return state.wallets.buildWith(
      onRetry: () {
        notifier.applyFilter(state.filter);
      },
      loadingBuilder: () => ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const WalletCardShimmer(),
      ),
      dataBuilder: (wallets) => ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: wallets.length,
          itemBuilder: (context, index) => WalletCard(
                wallet: wallets[index],
                onPressed: () {
                  context.pushNamed(
                    RouteManager.walletDetailsRoute,
                    arguments: wallets[index].id,
                  );
                },
              )),
    );
  }

  void _showFilterWalletWidget(
      BuildContext context, WidgetRef ref, WalletsState state) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height / 3) * 2),
      builder: (context) => FilterWalletSheet(
          countries: state.countries,
          currentFilter: state.filter,
          onApply: ref.read(walletsNotifierProvider.notifier).applyFilter),
    );
  }
}
