import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_provider.dart';
import '../core/network/error_handlers.dart';
import '../data/repositories/remote_data.dart';
import '../data/repositories/remote_data_source.dart';

final remoteDataRef = Ref<RemoteDataSource>();
final errorHandler = Ref<ErrorHandler>();

class ServiceDI {
  static void initializeDependencies(BuildContext context) {
    errorHandler.bindLazy(context, () => AppErrorHandler(DioExceptionFormatter()));
    remoteDataRef.bindLazy(
        context,
        () => RemoteDataSourceImpl(
            dioClient: DioProvider.httpDio,
            errorHandler: errorHandler.of(context)));
  }
}
