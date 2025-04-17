

class OrderAmountDetails {
  final double subtotal;
  final double? discount; 
  final double tax;
  final String currencySymbol;

  const OrderAmountDetails({
    required this.subtotal,
    this.discount,
    required this.tax,
    this.currencySymbol = 'SAR',
  });

  double get total => subtotal - (discount ?? 0) + tax;

  List<AmountItem> getAmountItems() {
    final items = <AmountItem>[
      AmountItem(
        label: 'المجموع',
        value: subtotal,
        isTotal: false,
      ),
      if (discount != null) 
        AmountItem(
          label: 'الخصم',
          value: discount!,
          isTotal: false,
        ),
      AmountItem(
        label: 'الضريبة',
        value: tax,
        isTotal: false,
      ),
      AmountItem(
        label: 'الإجمالي',
        value: total,
        isTotal: true,
      ),
    ];
    return items;
  }

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} $currencySymbol';
  }
}
class AmountItem {
  final String label;
  final double value;
  final bool isTotal;

  const AmountItem({
    required this.label,
    required this.value,
    this.isTotal = false,
  });
}