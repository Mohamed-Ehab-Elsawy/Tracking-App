import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  AppLocalStorage._(); // coverage:ignore-line

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --- SharedPreferences --- //

  /// Save data (String, int, bool, double)
  static Future<void> set(String key, dynamic value) async {
    final prefs = await _instance;

    debugPrint("SharedPrefHelper → setData: key=$key, value=$value");

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else {
      debugPrint(
        "SharedPrefHelper ERROR → Unsupported type: ${value.runtimeType}",
      );
    }
  }

  static Future<String> getString({required String key}) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? '';
  }

  static Future<int> getInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? 0;
  }

  static Future<double> getDouble(String key) async {
    final prefs = await _instance;
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future<bool> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? false;
  }

  static Future<void> removeData(String key) async {
    final prefs = await _instance;
    debugPrint("SharedPrefHelper → removed key: $key");
    await prefs.remove(key);
  }

  static Future<void> clearAllData() async {
    final prefs = await _instance;
    debugPrint("SharedPrefHelper → all data cleared");
    await prefs.clear();
  }

  // --- Flutter Secure Storage --- //
  static FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> setSecuredString({
    required String key,
    required String value,
  }) async {
    debugPrint("SecureStorage → set: key=$key");
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String> getSecuredString({required String key}) async {
    debugPrint("SecureStorage → get: key=$key");
    return await _secureStorage.read(key: key) ?? '';
  }

  static Future<void> clearAllSecuredData() async {
    debugPrint("SecureStorage → all encrypted data cleared");
    await _secureStorage.deleteAll();
  }

  static Future<void> clearSecuredData({required String key}) async {
    debugPrint("SecureStorage → all encrypted data cleared");
    await _secureStorage.delete(key: key);
  }

  static void clearAll() {
    clearAllData();
    clearAllSecuredData();
  }

  // --- Test helpers ---
  @visibleForTesting
  static set prefsForTest(SharedPreferences prefs) => _prefs = prefs;

  @visibleForTesting
  static set secureStorageForTest(FlutterSecureStorage storage) =>
      _secureStorage = storage;
}
