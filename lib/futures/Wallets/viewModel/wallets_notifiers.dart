import 'package:signals/signals_flutter.dart';
import '../../../core/base/based_view_model.dart';
import '../../../data/repositories/remote_data_source.dart';
import 'Wallets_state.dart';

class WalletsViewModel extends BasedViewModel<WalletsState> {
  final RemoteDataSource _remoteDataSource;

  WalletsViewModel({
    required RemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(WalletsState());

  getWallets() async {
    updateState(state.value.copyWith(
      wallets: AsyncState.loading(),
    ));

    final response = await _remoteDataSource.getWallets(
      name: state.value.filter.name,
      minPrice: state.value.filter.minPrice,
      maxPrice: state.value.filter.maxPrice,
      countryId: state.value.filter.countryId,
    );

    updateState(
        state.value.copyWith(wallets: AsyncState.data(response.data ?? [])));
    await getCountries();
  }

  Future<void> getCountries() async {
    if (state.value.countries.isNotEmpty) return;

    final response = await _remoteDataSource.getCountries();
    updateState(state.value.copyWith(countries: response.data ?? []));
  }

  void clearFilters() {
    updateState(state.value.copyWith(
      filter: const WalletFilter(),
      countries: [],
    ));
  }

  void updatePartialFilter(WalletFilter partialFilter) {
    updateState(state.value.copyWith(
        filter: state.value.filter.copyWith(
      name: partialFilter.name,
      minPrice: partialFilter.minPrice,
      maxPrice: partialFilter.maxPrice,
      countryId: partialFilter.countryId,
    )));
    getWallets();
  }
}
