import 'wallet_category.dart';

class WalletDetails {
  final int id;
  final int walletCategoryId;
  final String name;
  final int order;
  final int days;
  final int availableDays;
  final List<NumberOfDays> numbersOfDays;
  final double price;
  final int occupancy;
  final double minUnitPrice;
  final double maxUnitPrice;
  final String currency;
  final double taxPercent;
  final bool active;
  final int type;
  final String description;
  final String walletImage;
  final String expiryDate;
  final List<dynamic> hotelStars;
  final WalletCategory walletCategory;
  final List<Feature> featuresFavorites;
  final List<WalletFeature> walletFeatures;
  final List<dynamic> walletPolicies;
  final List<Country> countries;
  final List<City> cities;
  final List<dynamic> hotels;
  final dynamic accommodationTypes;

  WalletDetails({
    required this.id,
    required this.walletCategoryId,
    required this.name,
    required this.order,
    required this.days,
    required this.availableDays,
    required this.numbersOfDays,
    required this.price,
    required this.occupancy,
    required this.minUnitPrice,
    required this.maxUnitPrice,
    required this.currency,
    required this.taxPercent,
    required this.active,
    required this.type,
    required this.description,
    required this.walletImage,
    required this.expiryDate,
    required this.hotelStars,
    required this.walletCategory,
    required this.featuresFavorites,
    required this.walletFeatures,
    required this.walletPolicies,
    required this.countries,
    required this.cities,
    required this.hotels,
    required this.accommodationTypes,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      id: json['id'] as int,
      walletCategoryId: json['wallet_category_id'] as int,
      name: json['name'] as String,
      order: json['order'] as int,
      days: json['days'] as int,
      availableDays: json['available_days'] as int,
      numbersOfDays: (json['numbers_of_days'] as List)
          .map((e) => NumberOfDays.fromJson(e))
          .toList(),
      price: json['price'].toDouble(),
      occupancy: json['occupancy'] as int,
      minUnitPrice: json['min_unit_price'].toDouble(),
      maxUnitPrice: json['max_unit_price'].toDouble(),
      currency: json['currency'] as String,
      taxPercent: json['tax_percent'].toDouble(),
      active: json['active'] as bool,
      type: json['type'] as int,
      description: json['description'] as String,
      walletImage: json['wallet_image'] as String,
      expiryDate: json['expiry_date'] as String,
      hotelStars: json['hotel_stars'] as List<dynamic>,
      walletCategory: WalletCategory.fromJson(json['wallet_category']),
      featuresFavorites: (json['features_favorites'] as List)
          .map((e) => Feature.fromJson(e))
          .toList(),
      walletFeatures: (json['Wallet_features'] as List)
          .map((e) => WalletFeature.fromJson(e))
          .toList(),
      walletPolicies: json['Wallet_policies'] as List<dynamic>,
      countries: (json['countries'] as List)
          .map((e) => Country.fromJson(e))
          .toList(),
      cities: (json['cities'] as List)
          .map((e) => City.fromJson(e))
          .toList(),
      hotels: json['hotels'] as List<dynamic>,
      accommodationTypes: json['accommodation_types'],
    );
  }

  
}

class NumberOfDays {
  final String days;
  final String expiryDays;
  final String expiryDate;

  NumberOfDays({
    required this.days,
    required this.expiryDays,
    required this.expiryDate,
  });

  factory NumberOfDays.fromJson(Map<String, dynamic> json) {
    return NumberOfDays(
      days: json['days'] as String,
      expiryDays: json['expiry_days'] as String,
      expiryDate: json['expiry_date'] as String,
    );
  }

 
}


class Feature {
  final String name;

  Feature({required this.name});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      name: json['name'] as String,
    );
  }

}

class WalletFeature {
  final int id;
  final String name;

  WalletFeature({required this.id, required this.name});

  factory WalletFeature.fromJson(Map<String, dynamic> json) {
    return WalletFeature(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  
}

class Country {
  final int id;
  final int apiId;
  final String name;
  final String iso;

  Country({
    required this.id,
    required this.apiId,
    required this.name,
    required this.iso,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      apiId: json['apiId'] as int,
      name: json['name'] as String,
      iso: json['iso'] as String,
    );
  }

 
}

class City {
  final int id;
  final int apiId;
  final int apiCityId;
  final int countryId;
  final String name;
  final String code;

  City({
    required this.id,
    required this.apiId,
    required this.apiCityId,
    required this.countryId,
    required this.name,
    required this.code,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      apiId: json['apiId'] as int,
      apiCityId: json['api_id'] as int,
      countryId: json['countryId'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

 
}