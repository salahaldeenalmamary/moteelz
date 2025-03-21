import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/wallet_details.dart';

enum PaymentStatus { initial, processing, success, error }

class WalletDetailsState {
  final String? selectedNumbersDay;
  final AsyncValue<WalletDetails> walletDetails;
  final int stepperNumber;
  final PaymentStatus paymentStatus;
  final String? paymentError;
  final String discountCode;
  final double? discountAmount;
  const WalletDetailsState({
    this.selectedNumbersDay,
    this.walletDetails = const AsyncValue.loading(),
    this.stepperNumber = 0,
    this.paymentStatus = PaymentStatus.initial,
    this.paymentError,
    this.discountCode = '',
    this.discountAmount ,
  });

  WalletDetailsState copyWith({
    String? selectedNumbersDay,
    AsyncValue<WalletDetails>? walletDetails,
    int? stepperNumber,
    PaymentStatus? paymentStatus,
    String? paymentError,
    String? discountCode,
    double? discountAmount,
  }) {
    return WalletDetailsState(
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentError: paymentError ?? this.paymentError,
      selectedNumbersDay: selectedNumbersDay ?? this.selectedNumbersDay,
      walletDetails: walletDetails ?? this.walletDetails,
      stepperNumber: stepperNumber ?? this.stepperNumber,
      discountCode: discountCode ?? this.discountCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  double get total {
    final price = walletDetails.value?.price;
    final days = double.tryParse(selectedNumbersDay?.toString() ?? '');

    if (price == null || days == null || days <= 0) return 0.0;

    return price * days;
  }

  double get taxAmount {
    final price = walletDetails.value?.price;
    final taxPercent = walletDetails.value?.taxPercent;

    if (price == null || taxPercent == null || taxPercent <= 0) return 0.0;

    return price / taxPercent;
  }
}

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
