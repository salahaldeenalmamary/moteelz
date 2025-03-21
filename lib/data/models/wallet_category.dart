abstract class BaseWalletCategory {
  final String name;

  const BaseWalletCategory({required this.name});
}

class WalletCategory extends BaseWalletCategory {
  const WalletCategory({required super.name});

  factory WalletCategory.fromJson(Map<String, dynamic> json) {
    return WalletCategory(name: json['name'] as String);
  }
}

class WalletCategoryDetails extends BaseWalletCategory {
  final int id;
  final String icon;

  const WalletCategoryDetails({
    required super.name,
    required this.id,
    required this.icon,
  });

  factory WalletCategoryDetails.fromJson(Map<String, dynamic> json) {
    return WalletCategoryDetails(
      name: json['name'] as String,
      id: json['id'] as int,
      icon: json['icon'] as String,
    );
  }
}
