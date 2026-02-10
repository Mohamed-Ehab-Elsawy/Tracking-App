import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences, FlutterSecureStorage])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();

    AppLocalStorage.prefsForTest = mockPrefs;
    AppLocalStorage.secureStorageForTest = mockSecureStorage;

    authRepository = AuthRepositoryImpl();
  });

  group('AuthRepositoryImpl Logout Test', () {
    test(
      "Should clear all data from SharedPreferences and FlutterSecureStorage",
      () async {
        // Arrange
        when(mockPrefs.clear()).thenAnswer((_) async => true);
        when(mockSecureStorage.deleteAll()).thenAnswer((_) async => {});

        // Act
        authRepository.logout();

        // Assert
        verify(AppLocalStorage.clearAll()).called(1);
      },
    );
  });
}
