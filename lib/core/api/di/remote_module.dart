import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/env/env.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';

@module
abstract class ApiModule {
  @lazySingleton
  ApiClient provideApiClient(Dio dio) {
    return ApiClient(dio, baseUrl: Env.baseUrl);
  }

  @preResolve
  @lazySingleton
  Future<Dio> provideDio(
    BaseOptions option,
    PrettyDioLogger logger,
    AuthInterceptor authInterceptor,
  ) async {
    var dio = Dio(option);
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(logger);

    final userToken = await AppLocalStorage.getSecuredString(
      key: AppConstants.userToken,
    );

    if (userToken.isNotEmpty) {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      };
    }

    return dio;
  }

  @lazySingleton
  BaseOptions providerOption() => BaseOptions(
    baseUrl: Env.baseUrl,
    sendTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  @lazySingleton
  PrettyDioLogger provideLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    );
  }
}

@lazySingleton
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AppLocalStorage.getSecuredString(
      key: AppConstants.userToken,
    );

    if (token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OTg3NmJkYmUzNjRlZjYxNDA1MTVmYWYiLCJpYXQiOjE3NzEyMDE3OTd9.E7yTCCU-TfX8cq0DF_sxW12QxOhtQo3cd4uA8bpQJPo';
    }

    super.onRequest(options, handler);
  }
}
