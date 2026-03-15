import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/use_case/driver_login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([DriverLoginUseCase])
void main() {
  late MockDriverLoginUseCase mockUseCase;
  late LoginCubit cubit;

  setUp(() {
    mockUseCase = MockDriverLoginUseCase();
    cubit = LoginCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  blocTest<LoginCubit, LoginViewState>(
    'emits [loading, loaded] and navigation events on success',
    build: () => cubit,
    setUp: () {
      provideDummy<Result<String>>(Success<String>('logged_in_successfully'));
      when(
        mockUseCase.call(any, any, any),
      ).thenAnswer((_) async => Success<String>('logged_in_successfully'));
    },
    act: (cubit) {
      cubit.doIntent(
        DriverLoginIntent(
          email: 'test@test.com',
          password: '123456',
          rememberMe: true,
        ),
      );
    },
    skip: 0,
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
            RequestState.loaded,
          )
          .having((s) => s.loginState.data, 'data', 'logged_in_successfully'),
    ],
    verify: (_) {
      verify(mockUseCase.call('test@test.com', '123456', true)).called(1);
    },
  );

  blocTest<LoginCubit, LoginViewState>(
    'emits [loading, error] and failure events on error',
    build: () => cubit,
    setUp: () {
      provideDummy<Result<String>>(Failure<String>('Invalid credentials'));
      when(
        mockUseCase.call(any, any, any),
      ).thenAnswer((_) async => Failure<String>('Invalid credentials'));
    },
    act: (cubit) {
      cubit.doIntent(
        DriverLoginIntent(
          email: 'wrong@test.com',
          password: '0000',
          rememberMe: false,
        ),
      );
    },
    skip: 0,
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
}
