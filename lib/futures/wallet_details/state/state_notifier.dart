
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/remote_data_source.dart';
import 'state_state.dart';

class WalletDetailsNotifier extends StateNotifier<WalletDetailsState> {
  final RemoteDataSource _remoteDataSource;

  WalletDetailsNotifier(this._remoteDataSource)
      : super(const WalletDetailsState());

  void selectNumbersDay(String days) {
    state = state.copyWith(selectedNumbersDay: days, paymentError: null);
  }

  Future<void> getWalletDetails(int walletId) async {
    state = state.copyWith(walletDetails: const AsyncValue.loading());
    try {
      final response = await _remoteDataSource.getWalletDetails(walletId);
      state = state.copyWith(
          walletDetails: AsyncValue.data(response.data!),
          stepperNumber: 0,
          selectedNumbersDay: response.data?.numbersOfDays.firstOrNull?.days);
    } catch (e, st) {
      state = state.copyWith(walletDetails: AsyncValue.error(e, st));
    }
  }

  void nextStep() {
    if (state.stepperNumber < 1) {
      state = state.copyWith(stepperNumber: state.stepperNumber + 1);
    }
  }

  void previousStep() {
    if (state.stepperNumber > 0) {
      state = state.copyWith(stepperNumber: state.stepperNumber - 1);
    }
  }

  void handleContinueToPay() {
    if (state.selectedNumbersDay == null) {
      state = state.copyWith(
        paymentError: 'الرجاء اختيار باقة قبل المتابعة',
        paymentStatus: PaymentStatus.error,
      );
      return;
    }

    if (state.stepperNumber == 0) {
      state = state.copyWith(
        stepperNumber: 1,
        paymentError: null,
        paymentStatus: PaymentStatus.initial,
      );
    }
  }

  Future<void> handlePayment( PaymentDetails paymentRequest) async {
    try {
      state = state.copyWith(
        paymentStatus: PaymentStatus.processing,
        paymentError: null,
      );

      final result = await AsyncValue.guard(() async {
        print(paymentRequest.toJson());
        await Future.delayed(const Duration(seconds: 2));
        return true;
      });

      state = state.copyWith(
        paymentStatus:
            result.hasError ? PaymentStatus.error : PaymentStatus.success,
        paymentError: result.hasError ? result.error.toString() : null,
      );
    } catch (e, st) {
      state = state.copyWith(
        paymentStatus: PaymentStatus.error,
        paymentError: 'حدث خطأ  : ${e.toString()}',
      );
    }
  }

  Future<void> SendDiscount( ) async {
    try {
     

      final result = await AsyncValue.guard<double>(() async {
        // amoute of discount
        await Future.delayed(const Duration(seconds: 1));
        return 4;
      });

      state = state.copyWith(
        discountAmount: result.value
      );
    } catch (e, st) {
      state = state.copyWith(
        paymentStatus: PaymentStatus.error,
        paymentError: 'حدث خطأ أثناء المعالجة: ${e.toString()}',
      );
    }
  }



void applyDiscount(String code) {
    
    state = state.copyWith(
      discountCode: code,
      
    );
  }


  void reset() {
    state = const WalletDetailsState();
  }
}
