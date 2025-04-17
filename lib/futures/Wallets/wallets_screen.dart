import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/core/extensions/async_state_u_i.dart';
import 'package:moteelz/core/extensions/context_extensions.dart';
import 'package:moteelz/core/extensions/navigation_extension.dart';
import 'package:moteelz/futures/Wallets/widget/custom_search_app_bar.dart';
import 'package:moteelz/futures/Wallets/widget/filter_wallet_widget.dart';
import '../../di/ref.dart';
import '../../routes/route_manager.dart';
import 'viewModel/Wallets_state.dart';
import 'viewModel/refs.dart';
import 'viewModel/wallets_notifiers.dart';
import 'widget/wallet_card.dart';
import 'package:context_plus/context_plus.dart';


class WalletsScreen extends StatelessWidget {
  WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    walletsRef.bind(
        context,
        () => WalletsViewModel(
              remoteDataSource: remoteDataRef.of(context),
            )..getWallets());

    final wallets = walletsRef.of(context).state.watchOnly(
          context,
          (value) => value.wallets,
        );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          'التصفية',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ),
        icon: const Icon(Icons.storage_outlined, color: Colors.white),
        onPressed: () => _showFilterWalletWidget(
            context, walletsRef.of(context).state.value),
      ),
      appBar: CustomSearchAppBar(
        onSearchChanged: (value) {
          walletsRef.of(context).getWallets();
        },
      ),
      body: RefreshIndicator.adaptive(
        child: wallets.buildWith(
          onRetry: () => walletsRef.of(context).getWallets(),
          loadingBuilder: () => ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => WalletCardShimmer(),
          ),
          dataBuilder: (wallets) => ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: wallets.length,
            itemBuilder: (context, index) => WalletCard(
              wallet: wallets[index],
              onPressed: () => context.pushNamed(
                RouteManager.walletDetailsRoute,
                arguments: wallets[index].id,
              ),
            ),
          ),
        ),
        onRefresh: () => walletsRef.of(context).getWallets(),
      ),
    );
  }

  void _showFilterWalletWidget(BuildContext context, WalletsState state) {
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: context.height * 0.66,
      ),
      builder: (context) => FilterWalletSheet(
        countries: state.countries,
        currentFilter: state.filter,
        onApply: (filter) => walletsRef.of(context).updatePartialFilter(filter),
      ),
    );
  }
}
