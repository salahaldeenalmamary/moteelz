import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'payment_form_notifier.dart';
import 'payment_form_state.dart';

final paymentFormProvider = StateNotifierProvider.autoDispose<PaymentFormNotifier, PaymentFormState>((ref) {
  return PaymentFormNotifier();
});