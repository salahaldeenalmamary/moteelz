import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moteelz/data/repositories/remote_data_source.dart';

import '../../core/network/dio_provider.dart';
import '../../core/network/error_handler_provider.dart';
import 'remote_data.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSourceImpl(
      dioClient: DioProvider.dioWithHeaderToken,
      errorHandler: ref.read(errorHandlerProvider));
});
