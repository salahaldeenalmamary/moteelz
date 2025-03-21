import 'package:moteelz/data/repositories/remote_data_source.dart';

import '../../core/base/base_remote_source.dart';
import '../../utils/ApiEndpoints.dart';
import '../models/ApiResponse.dart';
import '../models/filter_country.dart';
import '../models/wallet_details.dart';
import '../models/wallets.dart';


class RemoteDataSourceImpl extends BaseRemoteSource implements RemoteDataSource {
  RemoteDataSourceImpl({required super.dioClient, required super.errorHandler});

  @override
  Future<ApiResponse<List<FilterCountry>>> getCountries() async {
    final dioCall = dioClient.get(ApiEndpoints.filterCountries);
    final response = await callApiWithErrorParser(()=>dioCall);
    
    return ApiResponse<List<FilterCountry>>.fromJson(
      response.data,
      (data) => (data as List).map((e) => FilterCountry.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<List<Wallets>>> getWallets({
    String? name,
    int? minPrice,
    int? maxPrice,
    int? countryId,
  }) async {
    final url = ApiEndpoints.wallets(
      name: name,
      minPrice: minPrice,
      maxPrice: maxPrice,
      countryId: countryId,
    );
    
    final dioCall = dioClient.get(url);
    final response = await callApiWithErrorParser(()=>dioCall);
    
    return ApiResponse<List<Wallets>>.fromJson(
      response.data,
      (data) => (data as List).map((e) => Wallets.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<WalletDetails>> getWalletDetails(int walletId) async {
    final dioCall = dioClient.get(ApiEndpoints.walletDetails(walletId));
    final response = await callApiWithErrorParser(()=>dioCall);
    
    return ApiResponse<WalletDetails>.fromJson(
      response.data,
      (data) => WalletDetails.fromJson(data),
    );
  }
}
