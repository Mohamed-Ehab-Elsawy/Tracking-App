import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  provideDummy<Result<EmailVerificationResponseDto>>(
    Success(const EmailVerificationResponseDto()),
  );
  provideDummy<Result<VerificationCodeResponseDto>>(
    Success(const VerificationCodeResponseDto()),
  );
  provideDummy<Result<ResetPasswordResponseDto>>(
    Success(const ResetPasswordResponseDto()),
  );

  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockAuthRemoteDataSource);
  });

  const tUserEntity = UserEntity(email: 'test@example.com', code: '123456');
  const tUserDto = UserDto(email: 'test@example.com', code: '123456');

  group('sendResetPasswordCode', () {
    const tResponseDto = EmailVerificationResponseDto(message: 'Success');
    const tResponseEntity = EmailVerificationResponseEntity(message: 'Success');

    test(
      'should return Success when the call to remote data source is successful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.emailVerification(any),
        ).thenAnswer((_) async => Success(tResponseDto));

        // Act
        final result = await repository.sendResetPasswordCode(tUserEntity);

        // Assert
        expect(result, isA<Success<EmailVerificationResponseEntity>>());
        expect((result as Success).data, tResponseEntity);
        verify(mockAuthRemoteDataSource.emailVerification(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );

    test(
      'should return Failure when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.emailVerification(any),
        ).thenAnswer((_) async => Failure('Error'));

        // Act
        final result = await repository.sendResetPasswordCode(tUserEntity);

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'Error');
        verify(mockAuthRemoteDataSource.emailVerification(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });

  group('verifyResetPasswordCode', () {
    const tResponseDto = VerificationCodeResponseDto(status: 'Success');
    const tResponseEntity = VerificationCodeResponseEntity('Success');

    test(
      'should return Success when the call to remote data source is successful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.codeVerification(any),
        ).thenAnswer((_) async => Success(tResponseDto));

        // Act
        final result = await repository.verifyResetPasswordCode(tUserEntity);

        // Assert
        expect(result, isA<Success<VerificationCodeResponseEntity>>());
        expect((result as Success).data, tResponseEntity);
        verify(mockAuthRemoteDataSource.codeVerification(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );

    test(
      'should return Failure when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.codeVerification(any),
        ).thenAnswer((_) async => Failure('Error'));

        // Act
        final result = await repository.verifyResetPasswordCode(tUserEntity);

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'Error');
        verify(mockAuthRemoteDataSource.codeVerification(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });

  group('resetPassword', () {
    const tResponseDto = ResetPasswordResponseDto(
      message: 'Success',
      token: 'token',
    );
    const tResponseEntity = ResetPasswordResponseEntity(
      message: 'Success',
      token: 'token',
    );

    test(
      'should return Success when the call to remote data source is successful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.resetPassword(any),
        ).thenAnswer((_) async => Success(tResponseDto));

        // Act
        final result = await repository.resetPassword(tUserEntity);

        // Assert
        expect(result, isA<Success<ResetPasswordResponseEntity>>());
        expect((result as Success).data, tResponseEntity);
        verify(mockAuthRemoteDataSource.resetPassword(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );

    test(
      'should return Failure when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.resetPassword(any),
        ).thenAnswer((_) async => Failure('Error'));

        // Act
        final result = await repository.resetPassword(tUserEntity);

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'Error');
        verify(mockAuthRemoteDataSource.resetPassword(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });
}
