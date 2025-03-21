import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/remote_data_source_provider.dart';
import 'state_notifier.dart';
import 'state_state.dart';

final walletDetailsProvider = StateNotifierProvider.autoDispose
    .family<WalletDetailsNotifier, WalletDetailsState, int>(
  (ref, walletId) {
    final remoteDataSource = ref.watch(remoteDataSourceProvider);
    return WalletDetailsNotifier(remoteDataSource)..getWalletDetails(walletId);
  },
);
