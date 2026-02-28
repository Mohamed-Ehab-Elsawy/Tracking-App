import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/presentation/feedback/app_dialog.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_dialog.dart';

import 'logout_dialog_test.mocks.dart';

@GenerateMocks([LogoutCubit])
void main() {
  late MockLogoutCubit cubit;

  setUp(() => cubit = MockLogoutCubit());

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Widget buildTestWidget() => EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: AppThemeProvider(
      appTheme: LightTheme(),
      child: BlocProvider<LogoutCubit>.value(
        value: cubit,
        child: MaterialApp(
          routes: {
            AppRoutes.onboardingView: (_) =>
                const Scaffold(body: Text('Onboarding')),
          },
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  key: const Key('button'),
                  onPressed: () => showLogoutDialog(context),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('showLogoutDialog displays dialog with title and message', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('button')), findsOneWidget);
    await tester.tap(find.byKey(Key('button')));
    await tester.pumpAndSettle();

    expect(find.text('logout'.tr()), findsOneWidget);
    expect(find.text('confirm_logout_message'.tr()), findsOneWidget);
  });

  testWidgets('cancel button closes dialog', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(Key('button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('cancel'.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(AppDialog), findsNothing);
  });
}
