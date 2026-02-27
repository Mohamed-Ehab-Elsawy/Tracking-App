import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/domain/use_cases/change_password_use_case/change_password_use_case.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';

import 'change_password_view_model_test.mocks.dart';

@GenerateMocks([ChangePasswordUseCase])
void main() {
  late ChangePasswordViewModel viewModel;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUp(() {
    mockChangePasswordUseCase = MockChangePasswordUseCase();
    viewModel = ChangePasswordViewModel(mockChangePasswordUseCase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('ChangePassword Intent Tests', () {
    const password = "oldPassword123";
    const newPassword = "newPassword456";
    final changePasswordResponse = ChangePasswordResponse(
      message: "Password changed successfully",
    );
    final successResponse = Success<ChangePasswordResponse>(
      changePasswordResponse,
    );
    final failureResponse = Failure<ChangePasswordResponse>(
      "errors.connectionError",
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'should emit [loading, loaded] and trigger success UI events when changePassword succeeds',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<ChangePasswordResponse>>(successResponse);
        when(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async => successResponse);
      },
      act: (bloc) {
        expectLater(
          bloc.uiEventsStream,
          emitsInOrder([
            predicate<ChangePasswordShowToast>(
              (event) =>
                  event.message == "Password changed successfully" &&
                  !event.isError,
            ),
            isA<PopScreenIntent>(),
          ]),
        );

        bloc.doIntent(
          ChangePasswordIntent(password: password, newPassword: newPassword),
        );
      },
      expect: () => [
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loading,
        ),
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loaded &&
              state.changePasswordState.data?.message ==
                  "Password changed successfully",
        ),
      ],
      verify: (_) {
        verify(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockChangePasswordUseCase);
      },
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'should emit [loading, error] and trigger error UI event when changePassword fails',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<ChangePasswordResponse>>(failureResponse);
        when(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async => failureResponse);
      },
      act: (bloc) {
        expectLater(
          bloc.uiEventsStream,
          emits(
            predicate<ChangePasswordShowToast>(
              (event) =>
                  event.message == "errors.connectionError" && event.isError,
            ),
          ),
        );

        bloc.doIntent(
          ChangePasswordIntent(password: password, newPassword: newPassword),
        );
      },
      expect: () => [
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loading,
        ),
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.error &&
              state.changePasswordState.errorMessage ==
                  "errors.connectionError",
        ),
      ],
      verify: (_) {
        verify(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockChangePasswordUseCase);
      },
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'should handle null message gracefully and emit empty string in toast',
      build: () => viewModel,
      setUp: () {
        final responseWithNullMessage = ChangePasswordResponse(message: null);
        final successWithNullMessage = Success<ChangePasswordResponse>(
          responseWithNullMessage,
        );
        provideDummy<Result<ChangePasswordResponse>>(successWithNullMessage);
        when(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async => successWithNullMessage);
      },
      act: (bloc) {
        expectLater(
          bloc.uiEventsStream,
          emitsInOrder([
            predicate<ChangePasswordShowToast>(
              (event) => event.message == "" && !event.isError,
            ),
            isA<PopScreenIntent>(),
          ]),
        );

        bloc.doIntent(
          ChangePasswordIntent(password: password, newPassword: newPassword),
        );
      },
      expect: () => [
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loading,
        ),
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loaded &&
              state.changePasswordState.data?.message == null,
        ),
      ],
      verify: (_) {
        verify(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).called(1);
      },
    );

    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'should not emit PopScreenIntent when changePassword fails',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<ChangePasswordResponse>>(failureResponse);
        when(
          mockChangePasswordUseCase.call(
            password: password,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async => failureResponse);
      },
      act: (bloc) {
        expectLater(bloc.uiEventsStream, emits(isA<ChangePasswordShowToast>()));

        bloc.doIntent(
          ChangePasswordIntent(password: password, newPassword: newPassword),
        );
      },
      expect: () => [
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.loading,
        ),
        predicate<ChangePasswordState>(
          (state) =>
              state.changePasswordState.requestState == RequestState.error,
        ),
      ],
    );
  });

  group('Initial State Tests', () {
    test('should have correct initial state', () {
      expect(
        viewModel.state.changePasswordState.requestState,
        equals(RequestState.init),
      );
      expect(viewModel.state.changePasswordState.isInitial, isTrue);
    });

    test('initial state should not be loading', () {
      expect(viewModel.state.changePasswordState.isLoading, isFalse);
    });

    test('initial state should not be in error state', () {
      expect(viewModel.state.changePasswordState.isError, isFalse);
    });

    test('initial state should not be loaded', () {
      expect(viewModel.state.changePasswordState.isLoaded, isFalse);
    });

    test('initial state should have null data', () {
      expect(viewModel.state.changePasswordState.data, isNull);
    });

    test('initial state should have null errorMessage', () {
      expect(viewModel.state.changePasswordState.errorMessage, isNull);
    });
  });

  group('State Management Tests', () {
    test(
      'copyWith should create new state with updated changePasswordState',
      () {
        final initialState = ChangePasswordState.initial();
        final loadingState = BaseState<ChangePasswordResponse>.loading();

        final newState = initialState.copyWith(
          changePasswordState: loadingState,
        );

        expect(
          newState.changePasswordState.requestState,
          equals(RequestState.loading),
        );
        expect(newState.changePasswordState.isLoading, isTrue);
        expect(newState, isNot(same(initialState)));
      },
    );

    test('copyWith should keep old values when null is passed', () {
      final initialState = ChangePasswordState.initial();
      final newState = initialState.copyWith();

      expect(
        newState.changePasswordState.requestState,
        equals(initialState.changePasswordState.requestState),
      );
    });

    test('states with same values should be equal (Equatable)', () {
      final state1 = ChangePasswordState.initial();
      final state2 = ChangePasswordState.initial();

      expect(state1, equals(state2));
    });

    test('states with different requestState should not be equal', () {
      final state1 = ChangePasswordState.initial();
      final state2 = state1.copyWith(
        changePasswordState: BaseState<ChangePasswordResponse>.loading(),
      );

      expect(state1, isNot(equals(state2)));
    });
  });

  group('UI Events Stream Tests', () {
    test('uiEventsStream should be a broadcast stream', () {
      expect(viewModel.uiEventsStream.isBroadcast, isTrue);
    });

    test('should be able to listen to uiEventsStream multiple times', () {
      final subscription1 = viewModel.uiEventsStream.listen((_) {});
      final subscription2 = viewModel.uiEventsStream.listen((_) {});

      expect(subscription1, isNotNull);
      expect(subscription2, isNotNull);

      subscription1.cancel();
      subscription2.cancel();
    });

    test('should close stream controller when viewModel is closed', () async {
      await viewModel.close();
      expect(viewModel.isClosed, isTrue);
    });
  });

  group('Edge Cases Tests', () {
    test('should handle empty password strings', () {
      const emptyPassword = "";
      const emptyNewPassword = "";
      final failureResponse = Failure<ChangePasswordResponse>(
        "Password cannot be empty",
      );

      provideDummy<Result<ChangePasswordResponse>>(failureResponse);
      when(
        mockChangePasswordUseCase.call(
          password: emptyPassword,
          newPassword: emptyNewPassword,
        ),
      ).thenAnswer((_) async => failureResponse);

      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isLoading,
          ),
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isError,
          ),
        ]),
      );

      viewModel.doIntent(
        ChangePasswordIntent(
          password: emptyPassword,
          newPassword: emptyNewPassword,
        ),
      );
    });

    test('should handle very long password strings', () {
      final longPassword = "a" * 1000;
      final longNewPassword = "b" * 1000;
      final successResponse = Success<ChangePasswordResponse>(
        ChangePasswordResponse(message: "Success"),
      );

      provideDummy<Result<ChangePasswordResponse>>(successResponse);
      when(
        mockChangePasswordUseCase.call(
          password: longPassword,
          newPassword: longNewPassword,
        ),
      ).thenAnswer((_) async => successResponse);

      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isLoading,
          ),
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isLoaded,
          ),
        ]),
      );

      viewModel.doIntent(
        ChangePasswordIntent(
          password: longPassword,
          newPassword: longNewPassword,
        ),
      );
    });

    test('should handle special characters in password', () {
      const specialPassword = "P@ssw0rd!#\$%^&*()";
      const specialNewPassword = "N3wP@ss!@#\$";
      final successResponse = Success<ChangePasswordResponse>(
        ChangePasswordResponse(message: "Success"),
      );

      provideDummy<Result<ChangePasswordResponse>>(successResponse);
      when(
        mockChangePasswordUseCase.call(
          password: specialPassword,
          newPassword: specialNewPassword,
        ),
      ).thenAnswer((_) async => successResponse);

      expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isLoading,
          ),
          predicate<ChangePasswordState>(
            (state) => state.changePasswordState.isLoaded,
          ),
        ]),
      );

      viewModel.doIntent(
        ChangePasswordIntent(
          password: specialPassword,
          newPassword: specialNewPassword,
        ),
      );
    });
  });

  group('Multiple Intent Calls Tests', () {
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'should handle multiple consecutive intent calls correctly',
      build: () => viewModel,
      setUp: () {
        final response1 = Success<ChangePasswordResponse>(
          ChangePasswordResponse(message: "First success"),
        );
        final response2 = Success<ChangePasswordResponse>(
          ChangePasswordResponse(message: "Second success"),
        );

        provideDummy<Result<ChangePasswordResponse>>(response1);

        when(
          mockChangePasswordUseCase.call(
            password: "pass1",
            newPassword: "newPass1",
          ),
        ).thenAnswer((_) async => response1);

        when(
          mockChangePasswordUseCase.call(
            password: "pass2",
            newPassword: "newPass2",
          ),
        ).thenAnswer((_) async => response2);
      },
      act: (bloc) async {
        bloc.doIntent(
          ChangePasswordIntent(password: "pass1", newPassword: "newPass1"),
        );
        await Future.delayed(Duration(milliseconds: 100));
        bloc.doIntent(
          ChangePasswordIntent(password: "pass2", newPassword: "newPass2"),
        );
      },
      skip: 2,
      expect: () => [
        predicate<ChangePasswordState>(
          (state) => state.changePasswordState.isLoading,
        ),
        predicate<ChangePasswordState>(
          (state) => state.changePasswordState.isLoaded,
        ),
      ],
    );
  });
}
