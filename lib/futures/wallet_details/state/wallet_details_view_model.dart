
import 'package:signals/signals_flutter.dart';
import '../../../core/base/based_view_model.dart';
import '../../../data/repositories/remote_data_source.dart';
import 'state_state.dart';


class WalletDetailsViewModel extends BasedViewModel<WalletDetailsState> {
  final RemoteDataSource _remoteDataSource;

  WalletDetailsViewModel(this._remoteDataSource)
      : super(const WalletDetailsState(walletDetails: AsyncLoading()));


  
  void selectNumbersDay(String days) {
    updateState(state.value.copyWith(
      selectedNumbersDay: days,
      paymentError: null,
    ));
  }

  Future<void> getWalletDetails(int walletId) async {
    updateState(state.value.copyWith(walletDetails:  AsyncState.loading()));
    
    try {
      final response = await _remoteDataSource.getWalletDetails(walletId);
      updateState(state.value.copyWith(
        walletDetails: AsyncState.data(response.data!),
        stepperNumber: 0,
        selectedNumbersDay: response.data?.numbersOfDays.firstOrNull?.days,
      ));
    } catch (e, st) {
      updateState(state.value.copyWith(
        walletDetails: AsyncState.error(e, st),
      ));
    }
  }

  void nextStep() {
    if (state.value.stepperNumber < 1) {
      updateState(state.value.copyWith(
        stepperNumber: state.value.stepperNumber + 1,
      ));
    }
  }

  void previousStep() {
    if (state.value.stepperNumber > 0) {
      updateState(state.value.copyWith(
        stepperNumber: state.value.stepperNumber - 1,
      ));
    }
  }

  void handleContinueToPay() {
    if (state.value.selectedNumbersDay == null) {
      updateState(state.value.copyWith(
        paymentError: 'الرجاء اختيار باقة قبل المتابعة',
        paymentStatus: PaymentStatus.error,
      ));
      return;
    }

    if (state.value.stepperNumber == 0) {
      updateState(state.value.copyWith(
        stepperNumber: 1,
        paymentError: null,
        paymentStatus: PaymentStatus.initial,
      ));
    }
  }

  Future<void> handlePayment(PaymentDetails paymentRequest) async {
    try {
      updateState(state.value.copyWith(
        paymentStatus: PaymentStatus.processing,
        paymentError: null,
      ));

     
      await Future.delayed(const Duration(seconds: 2));
      
      updateState(state.value.copyWith(
        paymentStatus: PaymentStatus.success,
        paymentError: null,
      ));
    } catch (e) {
      updateState(state.value.copyWith(
        paymentStatus: PaymentStatus.error,
        paymentError: 'حدث خطأ : ${e.toString()}',
      ));
    }
  }

  Future<void> sendDiscount() async {
    try {
      
      updateState(state.value.copyWith(
        discountAmount:4,
      ));
    } catch (e, st) {
      updateState(state.value.copyWith(
        paymentError: 'حدث خطأ أثناء المعالجة: ${e.toString()}',
        paymentStatus: PaymentStatus.error,
      ));
    }
  }

  void applyDiscount(String code) {
    updateState(state.value.copyWith(
      discountCode: code,
    ));
  }

  @override
  void dispose() {
    
    super.dispose();
  }
}