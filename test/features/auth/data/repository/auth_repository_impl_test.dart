import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, SharedPreferences, FlutterSecureStorage])
void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositoryImpl authRepository;
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();

    AppLocalStorage.prefsForTest = mockPrefs;
    AppLocalStorage.secureStorageForTest = mockSecureStorage;

    authRepository = AuthRepositoryImpl(mockAuthRemoteDataSource);
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
        mockSecureStorage.write(key: AppConstants.userTokenKey, value: tToken),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepository.login(tEmail, tPassword, true);

      // Assert
      expect(result, isA<Success<String>>());
      expect((result as Success).data, 'logged_in_successfully');

      verify(mockPrefs.setBool(AppConstants.rememberMeKey, true)).called(1);
      verify(
        mockSecureStorage.write(key: AppConstants.userTokenKey, value: tToken),
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
