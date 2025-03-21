import 'package:moteelz/data/models/wallet_category.dart';

class Wallets {
  final int id;
  final String name;
  final int availableDays;
  final List<NumberOfDays> numbersOfDays;
  final int price;
  final String currency;
  final String walletImage;
  final String expiryDate;
  final WalletCategory walletCategory;
  final List<FeaturesFavorite> featuresFavorites;

  Wallets({
    required this.id,
    required this.name,
    required this.availableDays,
    required this.numbersOfDays,
    required this.price,
    required this.currency,
    required this.walletImage,
    required this.expiryDate,
    required this.walletCategory,
    required this.featuresFavorites,
  });

  factory Wallets.fromJson(Map<String, dynamic> json) {
    return Wallets(
      id: json['id'] as int,
      name: json['name'] as String,
      availableDays: json['available_days'] as int,
      numbersOfDays: (json['numbers_of_days'] as List)
          .map((e) => NumberOfDays.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as int,
      currency: json['currency'] as String,
      walletImage: json['wallet_image'] as String,
      expiryDate: json['expiry_date'] as String,
      walletCategory: WalletCategory.fromJson(
          json['wallet_category'] as Map<String, dynamic>),
      featuresFavorites: (json['features_favorites'] as List)
          .map((e) => FeaturesFavorite.fromJson(e as Map<String, dynamic>))
          .toList(),
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

class FeaturesFavorite {
  final String name;

  FeaturesFavorite({
    required this.name,
  });

  factory FeaturesFavorite.fromJson(Map<String, dynamic> json) {
    return FeaturesFavorite(
      name: json['name'] as String,
    );
  }
}
