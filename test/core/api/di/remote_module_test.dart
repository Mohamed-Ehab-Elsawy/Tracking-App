import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/api/di/remote_module.dart';
import 'package:tracking_app/core/constants/app_constants.dart';

import 'remote_module_test.mocks.dart';

@GenerateMocks([Dio])
class TestApiModule extends ApiModule {}

void main() {
  late TestApiModule module;
  late MockDio mockDio;

  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    module = TestApiModule();
    mockDio = MockDio();
    SharedPreferences.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'read') {
            if (methodCall.arguments['key'] == AppConstants.userToken) {
              return 'test_token_123';
            }
          }
          return null;
        });
  });

  group('provideDio', () {
    test(
      'adds logger to interceptors and sets auth header when token exists',
      () async {
        final options = BaseOptions();
        final logger = PrettyDioLogger();
        final interceptors = Interceptors();

        when(mockDio.options).thenReturn(options);
        when(mockDio.interceptors).thenReturn(interceptors);

        final result = await module.provideDio(options, logger);

        expect(result, isA<Dio>());
      },
    );

    test('does not set Authorization header when token is empty', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (MethodCall methodCall) async => null,
          );

      final options = BaseOptions();
      final logger = PrettyDioLogger();
      when(mockDio.options).thenReturn(options);
      when(mockDio.interceptors).thenReturn(Interceptors());

      final result = await module.provideDio(options, logger);

      expect(result.options.headers['Authorization'], isNull);
    });
  });
}
