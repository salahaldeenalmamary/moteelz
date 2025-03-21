import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:moteelz/core/extensions/async_value_u_i.dart';
import 'package:moteelz/core/extensions/navigation_extension.dart';
import 'package:moteelz/futures/wallet_details/widget/description_wallet_details_card_features.dart';
import 'package:moteelz/futures/wallet_details/widget/wallet_details_card_features.dart';
import 'package:moteelz/routes/route_manager.dart';
import '../../data/models/wallet_details.dart';
import 'state/order_amount_model.dart';
import 'payment_form/payment_form.dart';
import 'payment_form/payment_form_provider.dart';
import 'state/state_notifier.dart';
import 'state/state_provider.dart';
import 'state/state_state.dart';
import 'widget/discount_code_section.dart';
import 'widget/order_details_amounts_section.dart';
import 'widget/wallet_card.dart';

class WalletDetailsScreen extends ConsumerWidget {
  final int walletId;

  const WalletDetailsScreen({super.key, required this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletDetailsProvider(walletId));
    final notifier = ref.watch(walletDetailsProvider(walletId).notifier);

    final theme = Theme.of(context);

    ref.listen<WalletDetailsState>(walletDetailsProvider(walletId),
        (previous, current) {
      if (current.paymentStatus == PaymentStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSuccessDialog(context);
        });
      }
      if (current.paymentError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(current.paymentError ?? '')),
          );
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      bottomNavigationBar: _buildStepperControls(state, notifier),
      body: Stepper(
        type: StepperType.horizontal,
        margin: EdgeInsets.zero,
        currentStep: state.stepperNumber,
        connectorThickness: 5,
         connectorColor: MaterialStateProperty.all(theme.primaryColor),
        elevation: 3,
        onStepTapped: (value) {
          if (value == 1) {
            // notifier.nextStep();
          } else {
            notifier.previousStep();
          }
        },
        stepIconMargin: EdgeInsets.zero,
        controlsBuilder: (context, details) => SizedBox(),
        steps: [
          _buildPackageSelectionStep(state, notifier, theme),
          _buildPaymentStep(state, notifier, theme),
        ],
      ),
    );
  }

  Widget _buildStepperControls(
    WalletDetailsState state,
    WalletDetailsNotifier notifier,
  ) {
    return state.stepperNumber == 0
        ? CupertinoButton.filled(
            borderRadius: BorderRadius.zero,
            onPressed: () => notifier.handleContinueToPay(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('متابعة إلى الدفع'),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_right_alt_outlined)
              ],
            ),
          )
        : Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(paymentFormProvider);
              final formNotifier = ref.read(paymentFormProvider.notifier);

              return CupertinoButton.filled(
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  if (formNotifier.validate()) {
                    final details = PaymentDetails(
                        cardHolderName: formState.cardName,
                        cardNumber: formState.cardNumber,
                        expiryDate: formState.expiryDate,
                        cvc: formState.cvc,
                        selectedNumbersDay: state.selectedNumbersDay,
                        walletId: state.walletDetails.value?.id);
                    notifier.handlePayment(details);
                  }
                },
                child: const Text('ادفع الأن'),
              );
            },
          );
  }

  Step _buildPackageSelectionStep(
    WalletDetailsState state,
    WalletDetailsNotifier notifier,
    ThemeData theme,
  ) {
    return Step(
      state: StepState.indexed,
      
      label: const Text('البطاقة'),
      title: const Text(''),
      content: state.walletDetails.buildWith(
        dataBuilder: (details) => Column(
          children: [
            CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                separatorColor: theme.cardColor,
                topMargin: 0,
                children: [
                  WalletDetailsCard(
                    wallet: details,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    child: Text(
                      "اختار عدد الليالي:",
                      style: theme.textTheme.titleMedium,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  const SizedBox(height: 16),
                  _buildPackageGrid(state, details, notifier, theme),
                  const SizedBox(height: 16),
                ]),
            DescriptionWalletDetailsCardFeatures(
              description: details.description,
            ),
            WalletDetailsCardFeatures(
              featuresFavorites: details.featuresFavorites,
            ),
          ],
        ),
      ),
      isActive: state.stepperNumber == 0,
    );
  }

  
  Step _buildPaymentStep(
    WalletDetailsState state,
    WalletDetailsNotifier notifier,
    ThemeData theme,
  ) {
    return Step(
      stepStyle: StepStyle(color: theme.primaryColor, connectorThickness: 3),
      label: const Text('الدفع'),
      title: const Text(''),
      content: Column(
        children: [
          state.walletDetails.buildWith(
            dataBuilder: (data) {
              return WalletDetailsCard(
                wallet: data,
                total:
                    '${data.price * (double.tryParse(state.selectedNumbersDay.toString()) ?? 0.0) ?? 0.0} ${data.currency}',
                selectedNumberOfDay: state.selectedNumbersDay != null
                    ? data.numbersOfDays
                        .firstWhere((s) => s.days == state.selectedNumbersDay)
                    : null,
              );
            },
          ),
          DiscountCodeSection(
            onApplyDiscount: (p0) {
              notifier.applyDiscount(p0);
              notifier.SendDiscount();
            },
          ),
          OrderDetailsAmountsSection(
            amountDetails: OrderAmountDetails(
                subtotal: state.total,
                tax: state.taxAmount,
                discount: state.discountAmount),
          ),
          PaymentForm(),
          const SizedBox(height: 20),
        ],
      ),
      isActive: state.stepperNumber == 1,
    );
  }
Widget _buildPackageGrid(
    WalletDetailsState state,
    WalletDetails details,
    WalletDetailsNotifier notifier,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 8,
          children: details.numbersOfDays.map((package) {
            final isSelected = state.selectedNumbersDay == package.days;

            return GestureDetector(
              onTap: () => notifier.selectNumbersDay(package.days),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.transparent,
                  border: isSelected
                      ? DashedBorder.fromBorderSide(
                          dashLength: 5,
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey,
                            width: 1,
                          ),
                        )
                      : Border.all(
                          color: theme.chipTheme.side?.color ?? Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${package.days} ليلة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? theme.colorScheme.primary : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Text(
          "${(details.price * (double.tryParse(state.selectedNumbersDay.toString()) ?? 0.0)).toStringAsFixed(2)}${details.currency}",
          style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('تمت العملية بنجاح'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 16),
            Text('تم تأكيد الدفع بنجاح'),
          ],
        ),
        actions: [
          CupertinoButton.filled(
            alignment: Alignment.center,
          
            onPressed: () {
              context.pop(context);
              context.offAllNamed(RouteManager.walletsRoute);
            },
            child: const Text('الصفحة الرئسية'),
          ),
        ],
      ),
    );
  }
}
