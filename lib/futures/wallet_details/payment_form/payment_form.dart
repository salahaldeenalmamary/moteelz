
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'payment_form_notifier.dart';
import 'payment_form_provider.dart';
import 'payment_form_state.dart';

class PaymentForm extends ConsumerWidget {
  const PaymentForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentFormProvider);
    final notifier = ref.read(paymentFormProvider.notifier);
    final theme = Theme.of(context);

    return 
    CupertinoFormSection.insetGrouped(
      
      backgroundColor: theme.scaffoldBackgroundColor,
      margin: EdgeInsets.zero,
      header:  Text('بيانات الدفع', style: theme.textTheme.titleMedium?.copyWith(
          
        ),),
      children: [
    Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text('بطاقة الاتمان او الخصم المباشر', style: theme.textTheme.titleSmall?.copyWith(
          
        )),
          _buildCardNameField(state, notifier, theme, context),
          const SizedBox(height: 16),
          _buildCardNumberField(state, notifier, theme, context),
          const SizedBox(height: 16),
          _buildExpiryAndCvcFields(state, notifier, theme, context),
        ],
      ),
    )]);
  }

  Widget _buildCardNameField(PaymentFormState state,
      PaymentFormNotifier notifier, ThemeData theme, BuildContext context) {
    return _buildSection(
      context,
      title: 'اسم صاحب البطاقة',
      child: TextFormField(
        initialValue: state.cardName,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.cardColor,
          errorText: state.cardNameError,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        textInputAction: TextInputAction.next,
        onChanged: notifier.updateCardName,
      ),
    );
  }

  Widget _buildCardNumberField(PaymentFormState state,
      PaymentFormNotifier notifier, ThemeData theme, BuildContext context) {
    return _buildSection(
      context,
      title: 'رقم البطاقة',
      child: TextFormField(
        initialValue: state.cardNumber,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          errorText: state.cardNumberError,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          CardNumberFormatter(),
        ],
        textInputAction: TextInputAction.next,
        onChanged: notifier.updateCardNumber,
      ),
    );
  }

  Widget _buildExpiryAndCvcFields(PaymentFormState state,
      PaymentFormNotifier notifier, ThemeData theme, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSection(
            context,
            title: 'انتهاء الصلاحية',
            child: TextFormField(
              initialValue: state.expiryDate,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                errorText: state.expiryDateError,
                fillColor: theme.cardColor,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                CardExpiryFormatter(),
              ],
              textInputAction: TextInputAction.next,
              onChanged: notifier.updateExpiryDate,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSection(
            context,
            title: 'CVC',
            child: TextFormField(
              initialValue: state.cvc,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                errorText: state.cvcError,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: notifier.updateCvc,
              validator: (value) {
                if (value == null || value.isEmpty) return 'الرجاء إدخال CVC';
                if (value.length < 3 || value.length > 4) {
                  return 'CVC يجب أن يكون بين 3-4 أرقام';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  
                 
                ),
          ),
        ),
        child,
      ],
    );
  }
}


class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1) buffer.write('/');
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
