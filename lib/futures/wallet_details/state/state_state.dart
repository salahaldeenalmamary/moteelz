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
    
    final taxPercent = walletDetails.value?.taxPercent;

    if (taxPercent == null || taxPercent <= 0) return 0.0;

    return (total / taxPercent) ;
  }
}
