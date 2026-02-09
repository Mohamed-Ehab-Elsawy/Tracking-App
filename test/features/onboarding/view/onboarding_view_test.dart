import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/constants/keys_constants.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/onboarding/view/onboarding_view.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  setUp(() async {});
  testWidgets('onboarding view initial screen', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        appTheme: LightTheme(),
        child: const MaterialApp(
          home: OnboardingView(),
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
    expect(find.byType(OnboardingView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('welcomeTo'), findsOneWidget);
    expect(find.text('floweryRiderApp'), findsOneWidget);
    expect(find.text('login'), findsOneWidget);
    expect(find.text('apply'), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.applyKey)), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.loginKey)), findsOneWidget);
  });
  testWidgets('onboarding view navigation to login view', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        appTheme: LightTheme(),
        child: const MaterialApp(
          home: OnboardingView(),
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
    expect(find.byType(OnboardingView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('welcomeTo'), findsOneWidget);
    expect(find.text('floweryRiderApp'), findsOneWidget);
    expect(find.text('login'), findsOneWidget);
    expect(find.text('apply'), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.applyKey)), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.loginKey)), findsOneWidget);
    await tester.tap(find.byKey(const Key(KeysConstants.loginKey)));
    await tester.pumpAndSettle();
  });
  testWidgets('onboarding view navigation to apply view', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        appTheme: LightTheme(),
        child: const MaterialApp(
          home: OnboardingView(),
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
    expect(find.byType(OnboardingView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(4));
    expect(find.text('welcomeTo'), findsOneWidget);
    expect(find.text('floweryRiderApp'), findsOneWidget);
    expect(find.text('login'), findsOneWidget);
    expect(find.text('apply'), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.applyKey)), findsOneWidget);
    expect(find.byKey(const Key(KeysConstants.loginKey)), findsOneWidget);
    await tester.tap(find.byKey(const Key(KeysConstants.applyKey)));
    await tester.pumpAndSettle();
  });
}
