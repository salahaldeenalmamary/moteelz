
class PaymentFormState {
  final String cardName;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final FormStatus formStatus;
 final bool isSubmitted;
  const PaymentFormState({
    this.cardName = '',
    this.cardNumber = '',
    this.isSubmitted=false,
    this.expiryDate = '',
    this.cvc = '',
    this.formStatus = FormStatus.initial,
  });

  bool get isValid => 
      cardName.isNotEmpty &&
      _isValidCardNumber &&
    
      _isValidCvc;

  bool get _isValidCardNumber => cardNumber.replaceAll(' ', '').length == 16;

  bool get _isValidCvc => cvc.length >= 3 && cvc.length <= 4;


 String? get cardNameError => isSubmitted && cardName.isEmpty 
      ? 'الرجاء إدخال اسم صاحب البطاقة' 
      : null;

  String? get cardNumberError {
    if (!isSubmitted) return null;
    if (cardNumber.isEmpty) return 'الرجاء إدخال رقم البطاقة';
    if (cardNumber.replaceAll(' ', '').length != 16) {
      return 'رقم البطاقة يجب أن يكون 16 رقمًا';
    }
    return null;
  }

  String? get expiryDateError {
    if (!isSubmitted) return null;
    if (expiryDate.isEmpty) return 'الرجاء إدخال تاريخ الانتهاء';
  
    return null;
  }

  String? get cvcError {
    if (!isSubmitted) return null;
    if (cvc.isEmpty) return 'الرجاء إدخال CVC';
    if (cvc.length < 3 || cvc.length > 4) return 'CVC يجب أن يكون بين 3-4 أرقام';
    return null;
  }

  PaymentFormState copyWith({
    String? cardName,
    String? cardNumber,
    String? expiryDate,
    String? cvc,
    FormStatus? formStatus,
    bool? isSubmitted,
  }) {
    return PaymentFormState(
      isSubmitted: isSubmitted?? this.isSubmitted,
      cardName: cardName ?? this.cardName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvc: cvc ?? this.cvc,
      formStatus: formStatus ?? this.formStatus,
    );
  }
   
}

enum FormStatus { initial, validating, valid, invalid }
