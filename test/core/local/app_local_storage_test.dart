import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';

import 'app_local_storage_test.mocks.dart';

@GenerateMocks([SharedPreferences, FlutterSecureStorage])
void main() {
  late MockSharedPreferences mockPrefs;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockSecureStorage = MockFlutterSecureStorage();

    AppLocalStorage.prefsForTest = mockPrefs;
    AppLocalStorage.secureStorageForTest = mockSecureStorage;
  });

  group('SharedPreferences', () {
    test('set stores String', () async {
      when(mockPrefs.setString('key', 'value')).thenAnswer((_) async => true);

      await AppLocalStorage.set('key', 'value');

      verify(mockPrefs.setString('key', 'value')).called(1);
    });

    test('getString returns value', () async {
      when(mockPrefs.getString('key')).thenReturn('value');

      final result = await AppLocalStorage.getString(key: 'key');

      expect(result, 'value');
    });

    test('getString returns empty if null', () async {
      when(mockPrefs.getString('key')).thenReturn(null);

      final result = await AppLocalStorage.getString(key: 'key');

      expect(result, '');
    });

    test('removeData calls remove', () async {
      when(mockPrefs.remove('key')).thenAnswer((_) async => true);

      await AppLocalStorage.removeData('key');

      verify(mockPrefs.remove('key')).called(1);
    });

    test('clearAllData calls clear', () async {
      when(mockPrefs.clear()).thenAnswer((_) async => true);

      await AppLocalStorage.clearAllData();

      verify(mockPrefs.clear()).called(1);
    });
  });

  group('FlutterSecureStorage', () {
    test('setSecuredString calls write', () async {
      when(
        mockSecureStorage.write(key: 'key', value: 'secret'),
      ).thenAnswer((_) async {});

      await AppLocalStorage.setSecuredString(key: 'key', value: 'secret');

      verify(mockSecureStorage.write(key: 'key', value: 'secret')).called(1);
    });

    test('getSecuredString returns value', () async {
      when(
        mockSecureStorage.read(key: 'key'),
      ).thenAnswer((_) async => 'secret');

      final result = await AppLocalStorage.getSecuredString(key: 'key');

      expect(result, 'secret');
    });

    test('getSecuredString returns empty if null', () async {
      when(mockSecureStorage.read(key: 'key')).thenAnswer((_) async => null);

      final result = await AppLocalStorage.getSecuredString(key: 'key');

      expect(result, '');
    });

    test('clearSecuredData calls delete', () async {
      when(mockSecureStorage.delete(key: 'key')).thenAnswer((_) async {});

      await AppLocalStorage.clearSecuredData(key: 'key');

      verify(mockSecureStorage.delete(key: 'key')).called(1);
    });

    test('clearAllSecuredData calls deleteAll', () async {
      when(mockSecureStorage.deleteAll()).thenAnswer((_) async {});

      await AppLocalStorage.clearAllSecuredData();

      verify(mockSecureStorage.deleteAll()).called(1);
    });
  });
}
