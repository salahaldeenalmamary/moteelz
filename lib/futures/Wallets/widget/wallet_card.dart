import 'package:flutter/material.dart';
import 'package:moteelz/core/extensions/context_extensions.dart';

import 'package:moteelz/data/models/wallets.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widget/custom_image_view.dart';

class WalletCard extends StatelessWidget {
  final Wallets wallet;
  final VoidCallback? onPressed;

  const WalletCard({
    super.key,
    required this.wallet,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageView(
                  width: double.infinity,
                  height: 170,
                  imagePath: wallet.walletImage,
                ),
              ),

              SizedBox(
                height: 6,
              ),
              _buildDaysPackages(theme),
              Text(
                wallet.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Features List
              _buildFeaturesList(theme),
              const SizedBox(height: 16),
              _buildPriceSection(theme),
              // Action Button
            ],
          ),
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildDaysPackages(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "#${wallet.walletCategory.name}",
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(width: 8),
        Wrap(
          spacing: 2,
          runSpacing: 5,
          children: wallet.numbersOfDays.take(1).map((package) {
            return Chip(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.red.shade100,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              label: Text(
                '${package.days} ليالي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSection(ThemeData theme) {
    return Row(
      children: [
        Text(
          'السعر يبدا من:',
          style: theme.textTheme.titleMedium,
        ),
        Text(
          '${wallet.price} ${wallet.currency}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...wallet.featuresFavorites.map((feature) {
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
      ],
    );
  }
}

class WalletCardShimmer extends StatelessWidget {
  const WalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardMargin = const EdgeInsets.all(16);
    final cardPadding = const EdgeInsets.all(10);
    final double elementHeight = 16;
    final borderRadius = BorderRadius.circular(8);

    return Card(
      elevation: 2,
      margin: cardMargin,
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Days Packages Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: elementHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                    ),
                  ),
                  Wrap(
                    spacing: 2,
                    children: List.generate(
                        1,
                        (index) => Container(
                              width: 70,
                              height: 24,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                  ),
                ],
              ),
            ),

            // Features List Shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 80,
                    height: elementHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                    ),
                  ),
                  ...List.generate(
                      6,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 200,
                                  height: elementHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: borderRadius,
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),

            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: const SizedBox(height: 16),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: elementHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: elementHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
