class PaymentDetails {
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final int? walletId;
  final String? selectedNumbersDay;

  const PaymentDetails({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    this.walletId,
    this.selectedNumbersDay,
  });

  Map<String, dynamic> toJson() => {
        'card_holder_name': cardHolderName,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'cvc': cvc,
        'wallet_id': walletId,
        'selected_numbers_day': selectedNumbersDay,
      };
}
