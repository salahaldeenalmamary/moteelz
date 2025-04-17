import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:moteelz/core/extensions/widget_extensions.dart';

import '../state/order_amount_model.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل المبلغ',
          style: theme.textTheme.titleMedium,
        ),
        Column(
          children: [
            for (var item in amountItems) ...[
              if (item.isTotal) _buildDivider(theme),
              _buildAmountRow(context, item),
            ],
          ],
        ).paddingAll(10).decorated(color: theme.cardColor),
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
