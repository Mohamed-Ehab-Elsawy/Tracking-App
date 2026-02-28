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
  ) async {
    var dio = Dio(option);
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
