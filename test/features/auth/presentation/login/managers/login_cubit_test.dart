import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/domain/use_case/driver_login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([DriverLoginUseCase, FlutterSecureStorage, Dio])
void main() {
  late MockDriverLoginUseCase mockUseCase;
  late MockFlutterSecureStorage mockSecureStorage;
  late MockDio mockDio;
  late LoginCubit cubit;

  setUp(() {
    mockUseCase = MockDriverLoginUseCase();
    mockSecureStorage = MockFlutterSecureStorage();
    mockDio = MockDio();

    // Setup AppLocalStorage with mock secure storage
    AppLocalStorage.secureStorageForTest = mockSecureStorage;

    // Register mock Dio in GetIt
    if (getIt.isRegistered<Dio>()) {
      getIt.unregister<Dio>();
    }
    getIt.registerSingleton<Dio>(mockDio);

    // Stub Dio options as it's accessed in the cubit
    final options = BaseOptions();
    when(mockDio.options).thenReturn(options);

    cubit = LoginCubit(mockUseCase);
  });

  tearDown(() async {
    await cubit.close();
    await getIt.reset();
  });

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginViewState>(
      'emits [loading, loaded] and navigation event on success',
      build: () => cubit,
      setUp: () {
        provideDummy<Result<String>>(Success<String>('logged_in_successfully'));

        when(
          mockSecureStorage.read(key: AppConstants.userToken),
        ).thenAnswer((_) async => 'fake_token');

        when(
          mockUseCase.call(any, any, any),
        ).thenAnswer((_) async => Success<String>('logged_in_successfully'));
      },
      act: (cubit) => cubit.doIntent(
        DriverLoginIntent(
          email: 'test@test.com',
          password: '123456',
          rememberMe: true,
        ),
      ),
      expect: () => [
        isA<LoginViewState>().having(
          (s) => s.loginState.requestState,
          'loading',
          RequestState.loading,
        ),
        isA<LoginViewState>()
            .having(
              (s) => s.loginState.requestState,
              'loaded',
              RequestState.loaded,
            )
            .having((s) => s.loginState.data, 'data', 'logged_in_successfully'),
      ],
      verify: (_) {
        verify(mockUseCase.call('test@test.com', '123456', true)).called(1);
        // Verify the headers were set on the mock Dio
        expect(
          mockDio.options.headers['Authorization'],
          equals('Bearer fake_token'),
        );
      },
    );

    blocTest<LoginCubit, LoginViewState>(
      'emits [loading, error] and failure event on error',
      build: () => cubit,
      setUp: () {
        provideDummy<Result<String>>(Failure<String>('Invalid credentials'));
        when(
          mockUseCase.call(any, any, any),
        ).thenAnswer((_) async => Failure<String>('Invalid credentials'));
      },
      act: (cubit) => cubit.doIntent(
        DriverLoginIntent(
          email: 'wrong@test.com',
          password: '0000',
          rememberMe: false,
        ),
      ),
      expect: () => [
        isA<LoginViewState>().having(
          (s) => s.loginState.requestState,
          'requestState',
          RequestState.loading,
        ),
        isA<LoginViewState>()
            .having(
              (s) => s.loginState.requestState,
              'requestState',
              RequestState.error,
            )
            .having(
              (s) => s.loginState.errorMessage,
              'errorMessage',
              'Invalid credentials',
            ),
      ],
    );
    group('Event Stream Tests', () {
      blocTest<LoginCubit, LoginViewState>(
        'emits LoginNavToHomeEvent on success',
        build: () => cubit,
        setUp: () {
          provideDummy<Result<String>>(Success<String>('token'));
          when(
            mockSecureStorage.read(key: anyNamed('key')),
          ).thenAnswer((_) async => 'token');
          when(
            mockUseCase.call(any, any, any),
          ).thenAnswer((_) async => Success<String>('token'));
        },
        act: (cubit) => cubit.doIntent(
          DriverLoginIntent(email: 'e', password: 'p', rememberMe: true),
        ),
        verify: (cubit) {
          expect(cubit.eventStream, emits(isA<LoginNavToHomeEvent>()));
        },
      );

      blocTest<LoginCubit, LoginViewState>(
        'emits LoginFailureEvent on failure',
        build: () => cubit,
        setUp: () {
          provideDummy<Result<String>>(Failure<String>('error'));
          when(
            mockUseCase.call(any, any, any),
          ).thenAnswer((_) async => Failure<String>('error'));
        },
        act: (cubit) => cubit.doIntent(
          DriverLoginIntent(email: 'e', password: 'p', rememberMe: true),
        ),
        verify: (cubit) {
          expect(cubit.eventStream, emits(isA<LoginFailureEvent>()));
        },
      );
    });
  });
}
