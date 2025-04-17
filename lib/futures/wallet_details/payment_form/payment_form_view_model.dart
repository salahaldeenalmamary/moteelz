
import '../../../core/base/based_view_model.dart';
import 'payment_form_state.dart';

class PaymentFormViewModel extends BasedViewModel<PaymentFormState> {
  PaymentFormViewModel() : super(const PaymentFormState());

 
  void updateCardName(String value) => updateState(state.value.copyWith(cardName: value));
  void updateCardNumber(String value) => updateState(state.value.copyWith(cardNumber: value));
  void updateExpiryDate(String value) => updateState(state.value.copyWith(expiryDate: value));
  void updateCvc(String value) => updateState(state.value.copyWith(cvc: value));

  
  bool validate() {
    updateState(state.value.copyWith(
      
      isSubmitted: true,
    ));

    return state.value.isValid;
  }
}