
import 'package:moteelz/data/models/wallets.dart';
import 'package:signals/signals.dart';
import '../../../data/models/filter_country.dart';
class WalletFilter {
  final String? name;
  final int? minPrice;
  final int? maxPrice;
  final int? countryId;
  

  const WalletFilter({
    this.name,
    this.minPrice,
    this.maxPrice,
    this.countryId,
    
  });

  const WalletFilter.initial() : this();

  WalletFilter copyWith({
    String? name,
    int? minPrice,
    int? maxPrice,
    int? countryId,
    
  }) {
    return WalletFilter(
      name: name ?? this.name,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      countryId: countryId ?? this.countryId,
     
    );
  }

  bool get hasFilters =>
      name != null ||
      minPrice != null ||
      maxPrice != null ||
      countryId != null ;

  WalletFilter reset() => const WalletFilter.initial();
}


// Updated State
class WalletsState {
  final AsyncState<List<Wallets>> wallets;
  final WalletFilter filter;
  final List<FilterCountry> countries;

  const WalletsState({
    this.wallets = const AsyncLoading(isLoading: false),
    this.filter = const WalletFilter(),
    this.countries = const [],
  });

  WalletsState copyWith({
    AsyncState<List<Wallets>>? wallets,
    WalletFilter? filter,
    List<FilterCountry>? countries,
  }) {
    return WalletsState(
      wallets: wallets ?? this.wallets,
      filter: filter ?? this.filter,
      countries: countries ?? this.countries,
    );
  }
}
