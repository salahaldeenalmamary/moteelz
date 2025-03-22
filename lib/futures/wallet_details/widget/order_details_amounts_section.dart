
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../model/order_amount_model.dart';

class OrderDetailsAmountsSection extends StatelessWidget {
  final OrderAmountDetails amountDetails;

  const OrderDetailsAmountsSection({
    super.key,
    required this.amountDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountItems = amountDetails.getAmountItems();

    return CupertinoListSection(
      margin: EdgeInsets.zero,
      backgroundColor: theme.scaffoldBackgroundColor,
      separatorColor: theme.cardColor,
      header: Text(
        'تفاصيل المبلغ',
        style: theme.textTheme.titleMedium,
      ),
      children: [
        ...amountItems.expand((item) => [
          if (item.isTotal) _buildDivider(theme),
              _buildAmountRow(context, item),
              
            ]),
      ],
    );
  }

  Widget _buildAmountRow(BuildContext context, AmountItem item) {
    final theme = Theme.of(context);
    final formattedValue = amountDetails.formatCurrency(item.value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: item.isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
          ),
          Text(
            formattedValue,
            style: item.isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  )
                : theme.textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 1,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: DashedBorder.symmetric(
          dashLength: 1,
          spaceLength: 6,
          horizontal: BorderSide(color: theme.dividerColor),
        ),
      ),
    );
  }
}