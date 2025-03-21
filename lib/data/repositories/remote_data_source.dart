
import 'package:moteelz/data/models/ApiResponse.dart';
import 'package:moteelz/data/models/filter_country.dart';
import 'package:moteelz/data/models/wallet_details.dart';
import 'package:moteelz/data/models/wallets.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<List<FilterCountry>>> getCountries();
  Future<ApiResponse<List<Wallets>>> getWallets({
    String? name,
    int? minPrice,
    int? maxPrice,
    int? countryId,
  });
  Future<ApiResponse<WalletDetails>> getWalletDetails(int walletId);
}