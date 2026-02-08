import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/localization_constants.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/tracking_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('TrackingApp builds with correct initial route and theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale(LocalizationConstants.enLocaleKey),
          Locale(LocalizationConstants.arLocaleKey),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale(LocalizationConstants.enLocaleKey),
        child: const TrackingApp(),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.initialRoute, AppRoutes.forgetPasswordView);
    expect(materialApp.onGenerateRoute, isNotNull);

    expect(materialApp.title, isNotEmpty);

    expect(find.byType(AppThemeProvider), findsOneWidget);

    final context = tester.element(find.byType(MaterialApp));
    expect(context.locale.languageCode, LocalizationConstants.enLocaleKey);
  });
}
