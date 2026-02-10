import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/localization/model/app_language.dart';

void main() {
  test('English language locale should be en', () {
    expect(AppLanguage.english.locale, Locale('en'));
  });
  test('Arabic language locale should be en', () {
    expect(AppLanguage.arabic.locale, Locale('ar'));
  });
  test('English display name should be English', () {
    expect(AppLanguage.english.displayName, 'English');
  });
  test('Arabic display name should be English', () {
    expect(AppLanguage.arabic.displayName, 'Arabic');
  });
}
