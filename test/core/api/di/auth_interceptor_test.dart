import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/di/auth_interceptor.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';

import 'auth_interceptor_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage, RequestInterceptorHandler])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage mockStorage;
  late MockRequestInterceptorHandler mockHandler;
  late AuthInterceptor interceptor;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockHandler = MockRequestInterceptorHandler();
    AppLocalStorage.secureStorageForTest = mockStorage;
    interceptor = AuthInterceptor();
  });

  group('AuthInterceptor Tests', () {
    test('adds Authorization header when token exists', () async {
      when(
        mockStorage.read(key: AppConstants.userToken),
      ).thenAnswer((_) async => 'test_token_123');

      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, mockHandler);

      expect(options.headers['Authorization'], 'Bearer test_token_123');
      verify(mockHandler.next(options)).called(1);
    });

    test('does not add Authorization header when token is empty', () async {
      when(
        mockStorage.read(key: AppConstants.userToken),
      ).thenAnswer((_) async => '');

      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, mockHandler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(mockHandler.next(options)).called(1);
    });

    test('does not add Authorization header when token is null', () async {
      when(
        mockStorage.read(key: AppConstants.userToken),
      ).thenAnswer((_) async => null);

      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(options, mockHandler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(mockHandler.next(options)).called(1);
    });
  });
}
