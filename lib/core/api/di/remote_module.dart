import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/env/env.dart';

@module
abstract class ApiModule {
  @lazySingleton
  ApiClient provideApiClient(Dio dio) => ApiClient(dio, baseUrl: Env.baseUrl);

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

    final userToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OTk2M2IyZWUzNjRlZjYxNDA1YTE4YjgiLCJpYXQiOjE3NzE0NTMyMzB9.LdARWEewkVqCUblUxy7NNWOXg7tpjN-kLal613ytEH4';

    if (userToken.isNotEmpty) {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OTk2M2IyZWUzNjRlZjYxNDA1YTE4YjgiLCJpYXQiOjE3NzE0NTMyMzB9.LdARWEewkVqCUblUxy7NNWOXg7tpjN-kLal613ytEH4',
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
    final token = '';

    if (token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OTk2M2IyZWUzNjRlZjYxNDA1YTE4YjgiLCJpYXQiOjE3NzE0NTMyMzB9.LdARWEewkVqCUblUxy7NNWOXg7tpjN-kLal613ytEH4';
    }

    super.onRequest(options, handler);
  }
}
