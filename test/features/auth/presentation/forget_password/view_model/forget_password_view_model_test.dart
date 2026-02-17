import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

import 'forget_password_view_model_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late ForgetPasswordViewModel viewModel;
  late MockAuthRepository mockAuthRepository;

  final initialState = ForgetPasswordState(
    emailVerificationState: BaseState.init(),
    codeVerificationState: BaseState.init(),
    resetPasswordState: BaseState.init(),
    user: const UserEntity(),
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    viewModel = ForgetPasswordViewModel(mockAuthRepository);
  });

  const tUser = UserEntity(
    email: 'test@example.com',
    code: '123456',
    password: 'password123',
  );
  const tEmailResponse = EmailVerificationResponseEntity(message: 'Success');
  const tCodeResponse = VerificationCodeResponseEntity('Success');
  const tPasswordResponse = ResetPasswordResponseEntity(
    message: 'Success',
    token: 'token',
  );

  group('ForgetPasswordViewModel - EmailVerification', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, loaded] when EmailVerificationIntent is successful',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<EmailVerificationResponseEntity>>(
          Success(tEmailResponse),
        );
        when(
          mockAuthRepository.sendResetPasswordCode(any),
        ).thenAnswer((_) async => Success(tEmailResponse));
      },
      act: (cubit) => cubit.doIntent(EmailVerificationIntent(user: tUser)),
      expect: () => [
        initialState.copyWith(emailVerificationState: BaseState.loading()),
        initialState.copyWith(
          emailVerificationState: BaseState.loaded(tEmailResponse),
          user: tUser,
        ),
      ],
      verify: (_) {
        verify(mockAuthRepository.sendResetPasswordCode(tUser)).called(1);
      },
    );

    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, error] when EmailVerificationIntent fails',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<EmailVerificationResponseEntity>>(Failure('Error'));
        when(
          mockAuthRepository.sendResetPasswordCode(any),
        ).thenAnswer((_) async => Failure('Error'));
      },
      act: (cubit) => cubit.doIntent(EmailVerificationIntent(user: tUser)),
      expect: () => [
        initialState.copyWith(emailVerificationState: BaseState.loading()),
        initialState.copyWith(emailVerificationState: BaseState.error('Error')),
      ],
    );
  });

  group('ForgetPasswordViewModel - ReSendCode', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, loaded] when ReSendCodeIntent is successful',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<EmailVerificationResponseEntity>>(
          Success(tEmailResponse),
        );
        when(
          mockAuthRepository.sendResetPasswordCode(any),
        ).thenAnswer((_) async => Success(tEmailResponse));
      },
      act: (cubit) => cubit.doIntent(ReSendCodeIntent(user: tUser)),
      expect: () => [
        initialState.copyWith(emailVerificationState: BaseState.loading()),
        initialState.copyWith(
          emailVerificationState: BaseState.loaded(tEmailResponse),
          user: tUser,
        ),
      ],
    );
  });

  group('ForgetPasswordViewModel - CodeVerification', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, loaded] when CodeVerificationIntent is successful',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<VerificationCodeResponseEntity>>(
          Success(tCodeResponse),
        );
        when(
          mockAuthRepository.verifyResetPasswordCode(any),
        ).thenAnswer((_) async => Success(tCodeResponse));
      },
      act: (cubit) => cubit.doIntent(CodeVerificationIntent(user: tUser)),
      expect: () => [
        initialState.copyWith(codeVerificationState: BaseState.loading()),
        initialState.copyWith(
          codeVerificationState: BaseState.loaded(tCodeResponse),
        ),
      ],
    );
  });

  group('ForgetPasswordViewModel - ConfirmPassword', () {
    blocTest<ForgetPasswordViewModel, ForgetPasswordState>(
      'emits [loading, loaded] when ConfirmPasswordIntent is successful',
      build: () => viewModel,
      setUp: () {
        provideDummy<Result<ResetPasswordResponseEntity>>(
          Success(tPasswordResponse),
        );
        when(
          mockAuthRepository.resetPassword(any),
        ).thenAnswer((_) async => Success(tPasswordResponse));
      },
      act: (cubit) => cubit.doIntent(ConfirmPasswordIntent(user: tUser)),
      expect: () => [
        initialState.copyWith(resetPasswordState: BaseState.loading()),
        initialState.copyWith(
          resetPasswordState: BaseState.loaded(tPasswordResponse),
          user: tUser,
        ),
      ],
    );
  });
}
