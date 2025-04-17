import 'package:context_plus/context_plus.dart';
import 'package:context_watch_signals/context_watch_signals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:moteelz/core/extensions/async_state_u_i.dart';
import 'package:moteelz/core/extensions/navigation_extension.dart';
import 'package:moteelz/core/extensions/widget_extensions.dart';
import 'package:moteelz/futures/wallet_details/widget/description_wallet_details_card_features.dart';
import 'package:moteelz/futures/wallet_details/widget/wallet_details_card_features.dart';
import 'package:moteelz/routes/route_manager.dart';
import '../../data/models/wallet_details.dart';
import '../../di/ref.dart';
import 'payment_form/payment_form_view_model.dart';
import 'state/order_amount_model.dart';
import 'payment_form/payment_form.dart';
import 'payment_form/payment_form_provider.dart';
import 'state/ref.dart';
import 'state/wallet_details_view_model.dart';
import 'state/state_state.dart';
import 'widget/discount_code_section.dart';
import 'widget/order_details_amounts_section.dart';
import 'widget/step_progress_indicator.dart';
import 'widget/wallet_card.dart';


class WalletDetailsScreen extends StatelessWidget {
  final int walletId;

  const WalletDetailsScreen({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {


    paymentFormRef.bindLazy(context, () => PaymentFormViewModel());

    final state = walletsDetailsRef
        .bind(
          context,
          () => WalletDetailsViewModel(remoteDataRef.of(context))
            ..getWalletDetails(walletId),
        )
        .state.watch(
          context,
        );
    final dispatch = walletsDetailsRef.of(context);
    final theme = Theme.of(context);

    walletsDetailsRef.of(context).state.watchEffect(
      context,
      (value) {
        if (value.paymentStatus == PaymentStatus.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(context);
          });
        }
        if (value.paymentError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.paymentError ?? '')),
            );
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        bottom: _buildStepIndicator(state, theme),
      ),
      body: _buildContent(dispatch, theme),
      bottomNavigationBar: _buildActionButton(dispatch, context),
    );
  }

  PreferredSizeWidget _buildStepIndicator(
      WalletDetailsState state, ThemeData theme) {
    return StepProgressIndicator(
      currentStep: state.stepperNumber,
      stepTitles: const ['البطاقة', 'الدفع'],
      activeColor: theme.primaryColor,
      inactiveColor: Colors.grey[300],
      activeTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContent(WalletDetailsViewModel viewModel, ThemeData theme) {
    return IndexedStack(
      index: viewModel.state.value.stepperNumber,
      children: [
        _buildPackageSelectionContent(viewModel, theme),
        _buildPaymentContent(viewModel, theme),
      ],
    );
  }

  Widget _buildPackageSelectionContent(
      WalletDetailsViewModel viewModel, ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: viewModel.state.value.walletDetails.buildWith(
          dataBuilder: (details) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  WalletDetailsCard(wallet: details),
                  const SizedBox(height: 24),
                  _buildPackageGrid(viewModel, details, theme).paddingAll(10)
                ],
              ).decorated(color: theme.cardColor),
              const SizedBox(height: 24),
              DescriptionWalletDetailsCardFeatures(
                  description: details.description),
              const SizedBox(height: 24),
              WalletDetailsCardFeatures(
                  featuresFavorites: details.featuresFavorites),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentContent(
      WalletDetailsViewModel viewModel, ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            viewModel.state.value.walletDetails.buildWith(
              dataBuilder: (data) => WalletDetailsCard(
                wallet: data,
                total: '${viewModel.state.value.total} ${data.currency}',
                selectedNumberOfDay: viewModel.state.value.selectedNumbersDay != null
                    ? data.numbersOfDays.firstWhere(
                        (s) => s.days == viewModel.state.value.selectedNumbersDay)
                    : null,
              ),
            ),
            DiscountCodeSection(
              onApplyDiscount: (code) => viewModel.applyDiscount(code),
            ),
            OrderDetailsAmountsSection(
              amountDetails: OrderAmountDetails(
                  subtotal: viewModel.state.value.total,
                  tax: viewModel.state.value.taxAmount,
                  discount: viewModel.state.value.discountAmount),
            ),
            PaymentForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      WalletDetailsViewModel viewModel, BuildContext context) {
    return viewModel.state.value.stepperNumber == 0
        ? CupertinoButton.filled(
            borderRadius: BorderRadius.zero,
            onPressed: () => viewModel.handleContinueToPay(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('متابعة إلى الدفع'),
                const SizedBox(width: 5),
                const Icon(Icons.arrow_right_alt_outlined)
              ],
            ),
          )
        : CupertinoButton.filled(
            borderRadius: BorderRadius.zero,
            onPressed: () {
              final formViewModel = paymentFormRef.of(context);
              if (formViewModel.validate()) {
                final details = PaymentDetails(
                  cardHolderName: formViewModel.state.value.cardName,
                  cardNumber: formViewModel.state.value.cardNumber,
                  expiryDate: formViewModel.state.value.expiryDate,
                  cvc: formViewModel.state.value.cvc,
                  selectedNumbersDay: viewModel.state.value.selectedNumbersDay,
                  walletId: viewModel.state.value.walletDetails.value?.id,
                );

                viewModel.handlePayment(details);
              }
            },
            child: const Text('ادفع الأن'),
          );
    ;
  }

  Widget _buildPackageGrid(
    WalletDetailsViewModel viewModel,
    WalletDetails details,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 8,
          children: details.numbersOfDays.map((package) {
            final isSelected =
                viewModel.state.value.selectedNumbersDay == package.days;

            return GestureDetector(
              onTap: () => viewModel.selectNumbersDay(package.days),
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
          "${viewModel.state.value.total}${details.currency}",
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
