import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, SharedPreferences, FlutterSecureStorage])
void main() {
  late AuthRepositoryImpl authRepositoryImpl;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(mockAuthRemoteDataSource);
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();

    AppLocalStorage.prefsForTest = mockPrefs;
    AppLocalStorage.secureStorageForTest = mockSecureStorage;
  });
  const tUserEntity = UserEntity(email: 'test@example.com', code: '123456');
  const tUserDto = UserDto(email: 'test@example.com', code: '123456');

  group('sendResetPasswordCode', () {
    provideDummy<Result<EmailVerificationResponseDto>>(
      Success(const EmailVerificationResponseDto()),
    );
    provideDummy<Result<VerificationCodeResponseDto>>(
      Success(const VerificationCodeResponseDto()),
    );
    provideDummy<Result<ResetPasswordResponseDto>>(
      Success(const ResetPasswordResponseDto()),
    );
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
        final result = await authRepositoryImpl.sendResetPasswordCode(
          tUserEntity,
        );

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
        final result = await authRepositoryImpl.sendResetPasswordCode(
          tUserEntity,
        );

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
    provideDummy<Result<EmailVerificationResponseDto>>(
      Success(const EmailVerificationResponseDto()),
    );
    provideDummy<Result<VerificationCodeResponseDto>>(
      Success(const VerificationCodeResponseDto()),
    );
    provideDummy<Result<ResetPasswordResponseDto>>(
      Success(const ResetPasswordResponseDto()),
    );
    test(
      'should return Success when the call to remote data source is successful',
      () async {
        // Arrange
        when(
          mockAuthRemoteDataSource.codeVerification(any),
        ).thenAnswer((_) async => Success(tResponseDto));

        // Act
        final result = await authRepositoryImpl.verifyResetPasswordCode(
          tUserEntity,
        );

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
        final result = await authRepositoryImpl.verifyResetPasswordCode(
          tUserEntity,
        );

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'Error');
        verify(mockAuthRemoteDataSource.codeVerification(tUserDto));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });

  group('resetPassword', () {
    provideDummy<Result<EmailVerificationResponseDto>>(
      Success(const EmailVerificationResponseDto()),
    );
    provideDummy<Result<VerificationCodeResponseDto>>(
      Success(const VerificationCodeResponseDto()),
    );
    provideDummy<Result<ResetPasswordResponseDto>>(
      Success(const ResetPasswordResponseDto()),
    );
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
        final result = await authRepositoryImpl.resetPassword(tUserEntity);

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
        final result = await authRepositoryImpl.resetPassword(tUserEntity);

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
      final result = await authRepositoryImpl.login(tEmail, tPassword, true);

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
        final result = await authRepositoryImpl.login(tEmail, tPassword, false);

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
      final result = await authRepositoryImpl.login(tEmail, tPassword, true);

      // assert
      expect(result, isA<Failure<String>>());
      expect((result as Failure<String>).errorMessage, 'invalid_credentials');

      verify(mockAuthRemoteDataSource.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
    });
  });

  group('getAllVehicles', () {
    setUp(() {
      provideDummy<Result<ApplyResponse>>(Success(ApplyResponse()));
      provideDummy<Result<GetAllVehiclesResponse>>(
        Success(GetAllVehiclesResponse()),
      );
    });

    test(
      'should return Success<List<VehicleEntity>> when dataSource returns success',
      () async {
        final tVehiclesModel = [Vehicles(id: "1", type: "Car")];
        final tResponse = GetAllVehiclesResponse(vehicles: tVehiclesModel);

        when(
          mockAuthRemoteDataSource.getAllVehicles(),
        ).thenAnswer((_) async => Success(tResponse));

        final result = await authRepositoryImpl.getAllVehicles();

        expect(result, isA<Success<List<VehicleEntity>>>());
        expect((result as Success).data.first.id, "1");
      },
    );

    test('should return Failure when dataSource returns failure', () async {
      when(
        mockAuthRemoteDataSource.getAllVehicles(),
      ).thenAnswer((_) async => Failure("error_msg"));

      final result = await authRepositoryImpl.getAllVehicles();

      expect(result, isA<Failure<List<VehicleEntity>>>());
      expect((result as Failure).errorMessage, "error_msg");
    });
  });

  group('apply', () {
    final tDriverEntity = DriverEntity(firstName: "Ahmed", email: "a@a.com");
    final tFile = File('dummy');

    setUp(() {
      provideDummy<Result<ApplyResponse>>(Success(ApplyResponse()));
      provideDummy<Result<GetAllVehiclesResponse>>(
        Success(GetAllVehiclesResponse()),
      );
    });

    test(
      'should return Success<ApplyResponseEntity> when dataSource returns success',
      () async {
        final tApplyResponse = ApplyResponse(
          message: "success",
          token: "token123",
        );
        when(
          mockAuthRemoteDataSource.apply(
            any,
            nidImage: anyNamed('nidImage'),
            vehicleLicense: anyNamed('vehicleLicense'),
          ),
        ).thenAnswer((_) async => Success(tApplyResponse));

        final result = await authRepositoryImpl.apply(
          tDriverEntity,
          nidImage: tFile,
          vehicleLicense: tFile,
        );

        expect(result, isA<Success<ApplyResponseEntity>>());
        expect((result as Success).data.token, "token123");
      },
    );

    test('should return Failure when dataSource returns failure', () async {
      provideDummy<Result<ApplyResponse>>(Success(ApplyResponse()));
      provideDummy<Result<GetAllVehiclesResponse>>(
        Success(GetAllVehiclesResponse()),
      );
      when(
        mockAuthRemoteDataSource.apply(
          any,
          nidImage: anyNamed('nidImage'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer((_) async => Failure("server_error"));

      final result = await authRepositoryImpl.apply(
        tDriverEntity,
        nidImage: tFile,
        vehicleLicense: tFile,
      );

      expect(result, isA<Failure<ApplyResponseEntity>>());
      expect((result as Failure).errorMessage, "server_error");
    });
  });
}
