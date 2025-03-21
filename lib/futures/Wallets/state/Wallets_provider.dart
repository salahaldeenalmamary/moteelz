import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/remote_data_source_provider.dart';
import 'Wallets_notifier.dart';
import 'Wallets_state.dart';

  final walletsNotifierProvider =
    StateNotifierProvider<WalletsNotifier, WalletsState>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  return WalletsNotifier(remoteDataSource);
});