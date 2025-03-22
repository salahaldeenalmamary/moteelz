import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'payment_form_state.dart';

 // payment_form_provider.dart


class PaymentFormNotifier extends StateNotifier<PaymentFormState> {
  PaymentFormNotifier() : super(const PaymentFormState());

  void updateCardName(String value) => state = state.copyWith(cardName: value);
  void updateCardNumber(String value) => state = state.copyWith(cardNumber: value);
  void updateExpiryDate(String value) => state = state.copyWith(expiryDate: value);
  void updateCvc(String value) => state = state.copyWith(cvc: value);

  bool validate() {
    state = state.copyWith(formStatus: FormStatus.validating,isSubmitted: true );
    final isValid = state.isValid;
    state = state.copyWith(formStatus: isValid ?
     FormStatus.valid : FormStatus.invalid);
    return isValid;
  }

 
}