import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/core/extensions/context_extensions.dart';
import 'package:moteelz/core/extensions/widget_extensions.dart';
import '../../../data/models/wallet_details.dart';
import '../../../widget/custom_image_view.dart';

class WalletDetailsCard extends StatelessWidget {
  final WalletDetails wallet;
final String ?total;
final NumberOfDays? selectedNumberOfDay;
  const WalletDetailsCard({
    super.key,
    this.selectedNumberOfDay,
    required this.wallet,
    this.total,
 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   

    return Material(
      
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        CustomImageView(
          height: 90,
          width: 140,
          margin: EdgeInsets.only(left: 10),
          radius: BorderRadius.circular(20),
          imagePath: wallet.walletImage,
          fit: BoxFit.fill,

        ),

        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              wallet.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "#${wallet.walletCategory.name}",
              style: theme.textTheme.bodyMedium
                  ?.copyWith( color: Colors.grey),
            ),
if(total!=null)
             Text(
              total??'',
              style: theme.textTheme.titleSmall
                  ?.copyWith( color: theme.primaryColor),
            ),
          ],
        )), 
if(selectedNumberOfDay!=null)
        Chip(
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
                '${selectedNumberOfDay?.days} ليالي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
            )
      ],
    ),).paddingAll(10).decorated(color: context.theme.cardColor);
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
}
