import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/data/models/wallet_details.dart';

class WalletDetailsCardFeatures extends StatelessWidget {
  final List<Feature> featuresFavorites;

  const WalletDetailsCardFeatures({
    super.key,
    required this.featuresFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoListSection.insetGrouped(
      
      header: Text(
        "المميزات",
        style: theme.textTheme.titleMedium?.copyWith(
          
        ),
      ),
      backgroundColor: theme.cardColor,
      separatorColor: theme.cardColor,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
      children: featuresFavorites.map((feature) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: theme.primaryColor, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature.name.trim(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}