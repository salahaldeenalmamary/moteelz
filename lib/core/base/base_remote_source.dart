
import 'package:dio/dio.dart';
import '../network/error_handlers.dart';
import '../network/exceptions/base_exception.dart';

abstract class BaseRemoteSource {
  final Dio dioClient;
  final ErrorHandler errorHandler;

  const BaseRemoteSource({
    required this.dioClient,
    required this.errorHandler,
  });

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> Function() apiCall) async {
    try {
      final response = await apiCall();
      return response;
    } on DioException catch (dioError) {
      throw errorHandler.handleDioError(dioError);
    } catch (error) {
      if (error is BaseException) rethrow;
      throw errorHandler.handleError(error);
    }
  }
}
