import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/presentation/feedback/app_dialog.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_dialog.dart';

import 'logout_dialog_test.mocks.dart';

@GenerateMocks([LogoutCubit, NavigatorObserver])
void main() {
  Widget buildTestWidget({
    required LogoutCubit logoutCubit,
    required NavigatorObserver navigatorObserver,
  }) => EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: BlocProvider.value(
      value: logoutCubit,
      child: MaterialApp(
        navigatorObservers: [navigatorObserver],
        routes: {
          AppRoutes.onboardingView: (_) =>
              const Scaffold(body: Text('Onboarding')),
        },
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showLogoutDialog(context),
                child: const Text('open'),
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
    final cubit = MockLogoutCubit();
    final observer = MockNavigatorObserver();

    await tester.pumpWidget(
      buildTestWidget(logoutCubit: cubit, navigatorObserver: observer),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(AppDialog), findsOneWidget);
    expect(find.text('LOGOUT'), findsOneWidget);
    expect(find.text('confirm_logout_message'.tr()), findsOneWidget);
  });

  testWidgets('cancel button closes dialog', (tester) async {
    final cubit = MockLogoutCubit();
    final observer = MockNavigatorObserver();

    await tester.pumpWidget(
      buildTestWidget(logoutCubit: cubit, navigatorObserver: observer),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('cancel'.tr()));
    await tester.pumpAndSettle();

    expect(find.byType(AppDialog), findsNothing);
  });

  testWidgets('logout button calls cubit and navigates to onboarding', (
    tester,
  ) async {
    final cubit = MockLogoutCubit();
    final observer = MockNavigatorObserver();

    when(() => cubit.doIntent(any)).thenAnswer((_) => Future.value);

    await tester.pumpWidget(
      buildTestWidget(logoutCubit: cubit, navigatorObserver: observer),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('logout'.tr()));
    await tester.pumpAndSettle();

    verify(() => cubit.doIntent(any)).called(1);
    expect(find.text('Onboarding'), findsOneWidget);
  });
}
