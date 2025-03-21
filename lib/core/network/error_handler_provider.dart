import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_handlers.dart';

final errorHandlerProvider = Provider<ErrorHandler>((ref) {

  return AppErrorHandler(DioExceptionFormatter());
});