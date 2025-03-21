import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/wallets.dart';
import '../../../data/repositories/remote_data_source.dart';
import 'Wallets_state.dart';

class WalletsNotifier extends StateNotifier<WalletsState> {
  final RemoteDataSource _remoteDataSource;

  WalletsNotifier(this._remoteDataSource) : super(const WalletsState()) {
    applyFilter(WalletFilter.initial());
  }

  Future<void> applyFilter(WalletFilter newFilter) async {
    state = state.copyWith(
      filter: newFilter,
      wallets: const AsyncLoading(),
    );

    final newState = await AsyncValue.guard<List<Wallets>>(() async {
      final response = await _remoteDataSource.getWallets(
        name: newFilter.name,
        minPrice: newFilter.minPrice,
        maxPrice: newFilter.maxPrice,
        countryId: newFilter.countryId,
      );
      return response.data ?? [];
    });

    state = state.copyWith(
      wallets: newState,
    );
    await getCountries();
  }

  Future<void> getCountries() async {
    if(state.countries.isNotEmpty) return;
    final response = await _remoteDataSource.getCountries();
    state = state.copyWith(
      countries: response.data,
    );
    ;
  }

  void clearFilters() {
    state = state.copyWith(
      countries: [],
      filter: const WalletFilter(),
    );
  }

  void updatePartialFilter(WalletFilter partialFilter) {
    final newFilter = state.filter.copyWith(
      name: partialFilter.name,
      minPrice: partialFilter.minPrice,
      maxPrice: partialFilter.maxPrice,
      countryId: partialFilter.countryId,
    );
    applyFilter(newFilter);
  }
}
