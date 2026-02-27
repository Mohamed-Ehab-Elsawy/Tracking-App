import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/auth/presentation/login/login_view.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:tracking_app/features/auth/presentation/widgets/remember_me_check_box.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([LoginCubit])
void main() {
  late MockLoginCubit mockLoginCubit;
  late StreamController<LoginViewEvent> eventController;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockLoginCubit = MockLoginCubit();
    eventController = StreamController<LoginViewEvent>.broadcast();

    // Stubbing the stream
    when(mockLoginCubit.eventStream).thenAnswer((_) => eventController.stream);
    when(mockLoginCubit.state).thenReturn(LoginViewState.init());
    when(
      mockLoginCubit.stream,
    ).thenAnswer((_) => Stream.value(LoginViewState.init()));

    getIt.registerSingleton<LoginCubit>(mockLoginCubit);
  });

  tearDown(() {
    eventController.close();
    getIt.reset();
  });

  Widget buildTestableWidget(Widget child) => EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        routes: {
          '/': (_) => child,
          AppRoutes.homeView: (_) => const Scaffold(body: Text('HOME')),
          AppRoutes.forgetPasswordView: (_) =>
              const Scaffold(body: Text('FORGET')),
        },
      ),
    ),
  );

  testWidgets('renders all login widgets correctly', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle(); // Wait for localization
    });

    expect(find.byType(CustomTextFormField), findsNWidgets(2));
    // Since localization might just return keys
    expect(find.text('email'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
    expect(find.byType(RememberMeCheckBox), findsOneWidget);
    expect(find.text('forgot_password'), findsOneWidget);
    expect(find.text('continue'), findsOneWidget);
  });

  testWidgets('shows error messages when fields are empty', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    await tester.tap(find.text('continue'));
    await tester.pumpAndSettle();

    // Expecting keys returned by FormValidators
    expect(find.text('validation.enterEmail'), findsOneWidget);
    expect(find.text('validation.enterPassword'), findsOneWidget);
    verifyNever(mockLoginCubit.doIntent(any));
  });

  testWidgets('shows error message for invalid email', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    await tester.enterText(
      find.widgetWithText(CustomTextFormField, 'email'),
      'invalid-email',
    );
    await tester.enterText(
      find.widgetWithText(CustomTextFormField, 'password'),
      'Password@123',
    ); // Valid password
    await tester.tap(find.text('continue'));
    await tester.pumpAndSettle();

    expect(find.text('validation.validEmail'), findsOneWidget);
    verifyNever(mockLoginCubit.doIntent(any));
  });

  testWidgets('calls doIntent with correct data on valid submission', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    await tester.enterText(
      find.widgetWithText(CustomTextFormField, 'email'),
      'test@test.com',
    );
    // Needs to meet password criteria: 8 chars, Upper, Lower, Digit, Special
    await tester.enterText(
      find.widgetWithText(CustomTextFormField, 'password'),
      'Password@123',
    );

    // Check remember me (optional)
    await tester.tap(find.byType(Checkbox));

    await tester.tap(find.text('continue'));
    await tester.pump();

    final captured = verify(mockLoginCubit.doIntent(captureAny)).captured;
    final intent = captured.first as DriverLoginIntent;
    expect(intent.email, 'test@test.com');
    expect(intent.password, 'Password@123');

    expect(intent.rememberMe, true);
  });

  testWidgets('navigates to forget password when button is pressed', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    await tester.tap(find.text('forgot_password'));

    verify(mockLoginCubit.emitEvent(any)).called(1);

    // Simulate the event emission to test navigation
    eventController.add(LoginNavToForgetPasswordEvent());
    await tester.pumpAndSettle();

    expect(find.text('FORGET'), findsOneWidget);
  });

  testWidgets('shows LoadingIndicator when state is loading', (tester) async {
    when(mockLoginCubit.state).thenReturn(LoginViewState(BaseState.loading()));
    // Because BlocBuilder listens to stream:
    when(
      mockLoginCubit.stream,
    ).thenAnswer((_) => Stream.value(LoginViewState(BaseState.loading())));

    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pump(); // Initial build
    });

    await tester.pump(); // trigger builder

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.text('continue'), findsNothing);
  });

  testWidgets('navigates to home when LoginNavToHomeEvent is emitted', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    eventController.add(LoginNavToHomeEvent());
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('shows AppSnackBar when LoginFailureEvent is emitted', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(buildTestableWidget(const LoginView()));
      await tester.pumpAndSettle();
    });

    eventController.add(LoginFailureEvent(errorMessage: 'Login Failed'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Login Failed'), findsOneWidget);
  });
}
