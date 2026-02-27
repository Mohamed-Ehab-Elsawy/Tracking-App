import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';

import '../../../../core/local/app_local_storage_test.mocks.dart'
    show MockFlutterSecureStorage, MockSharedPreferences;
import 'auth_repository_impl_test.mocks.dart'
    hide MockSharedPreferences, MockFlutterSecureStorage;

@GenerateMocks([AuthRemoteDataSource, SharedPreferences, FlutterSecureStorage])
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
  late AuthRepositoryImpl authRepository;
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockAuthRemoteDataSource);

    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();

    AppLocalStorage.prefsForTest = mockPrefs;
    AppLocalStorage.secureStorageForTest = mockSecureStorage;

    authRepository = AuthRepositoryImpl(mockAuthRemoteDataSource);
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

  group('AuthRepositoryImpl Login Tests', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tToken = 'fake_jwt_token';

    test('should store token and rememberMe flag when login is successful and'
        'rememberMe is true', () async {
      // Arrange
      provideDummy<Result<String>>(Success(tToken));
      when(
        mockAuthRemoteDataSource.login(any, any),
      ).thenAnswer((_) async => Success(tToken));
      when(
        mockPrefs.setBool(AppConstants.rememberMeKey, true),
      ).thenAnswer((_) async => true);
      when(
        mockSecureStorage.write(key: AppConstants.userToken, value: tToken),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepository.login(tEmail, tPassword, true);

      // Assert
      expect(result, isA<Success<String>>());
      expect((result as Success).data, 'logged_in_successfully');

      verify(mockPrefs.setBool(AppConstants.rememberMeKey, true)).called(1);
      verify(
        mockSecureStorage.write(key: AppConstants.userToken, value: tToken),
      ).called(1);
    });

    test(
      "Success login without rememberMe returns success message and does not store token",
      () async {
        // arrange
        provideDummy<Result<String>>(Success(tToken));
        when(
          mockAuthRemoteDataSource.login(tEmail, tPassword),
        ).thenAnswer((_) async => Success(tToken));

        // act
        final result = await authRepository.login(tEmail, tPassword, false);

        // assert
        expect(result, isA<Success<String>>());
        expect((result as Success<String>).data, 'logged_in_successfully');

        verify(mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );

    test("Failure login returns failure and does not store anything", () async {
      // arrange
      when(
        mockAuthRemoteDataSource.login(tEmail, tPassword),
      ).thenAnswer((_) async => Failure('invalid_credentials'));

      // act
      final result = await authRepository.login(tEmail, tPassword, true);

      // assert
      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).errorMessage, 'invalid_credentials');

      verify(mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
    });
  });
}
