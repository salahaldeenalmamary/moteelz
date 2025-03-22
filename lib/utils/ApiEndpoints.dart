class ApiEndpoints {
  static const String baseUrl = 'https://stage-api-v2.moteelz.com/api/v1';

  

  
  static const String filterCountries = '$baseUrl/filter/countries';

  static String wallets({
  String? name,
  int? minPrice,
  int? maxPrice,
  int? countryId,
}) {
  final queryParams = <String, String>{
    if (name != null) 'name': name,
    if (minPrice != null) 'min_price': minPrice.toString(),
    if (maxPrice != null) 'max_price': maxPrice.toString(),
    if (countryId != null) 'country_id': countryId.toString(),
  };
  
  return Uri.parse('$baseUrl/wallets').replace(
    queryParameters: queryParams,
  ).toString();
}

  static String walletDetails(int walletId) => 
    '$baseUrl/wallet/details/$walletId';
}