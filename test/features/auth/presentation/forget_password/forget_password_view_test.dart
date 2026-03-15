import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/email_verification_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/code_verification_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_reset_step.dart';

import 'forget_password_view_test.mocks.dart';

@GenerateMocks([ForgetPasswordViewModel])
void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordUiEvent> navigationStreamController;

  final initialState = ForgetPasswordState(
    emailVerificationState: BaseState.init(),
    codeVerificationState: BaseState.init(),
    resetPasswordState: BaseState.init(),
    user: const UserEntity(),
  );

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    navigationStreamController =
        StreamController<ForgetPasswordUiEvent>.broadcast();

    when(mockViewModel.state).thenReturn(initialState);
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
    when(
      mockViewModel.eventStream,
    ).thenAnswer((_) => navigationStreamController.stream);
    when(mockViewModel.close()).thenAnswer((_) async => {});
  });

  tearDown(() {
    navigationStreamController.close();
  });

  Widget buildTestableWidget() {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        home: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: const ForgetPasswordView(),
        ),
      ),
    );
  }

  testWidgets(
    'ForgetPasswordView should render EmailVerificationStep initially',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(EmailVerificationStep), findsOneWidget);
      expect(find.text('forgetPassword.forgetPassword'), findsOneWidget);
    },
  );

  testWidgets(
    'ForgetPasswordView should navigate to CodeVerificationStep on ConfirmEmailEvent',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Trigger navigation events
      navigationStreamController.add(ConfirmEmailEvent());
      await tester.pumpAndSettle();

      expect(find.byType(CodeVerificationStep), findsOneWidget);
      expect(find.text('forgetPassword.emailVerification'), findsOneWidget);
    },
  );

  testWidgets(
    'ForgetPasswordView should navigate to PasswordResetStep on SendCodeEvent',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Navigate to second step first
      navigationStreamController.add(ConfirmEmailEvent());
      await tester.pumpAndSettle();

      // Trigger navigation to third step
      navigationStreamController.add(SendCodeEvent());
      await tester.pumpAndSettle();

      expect(find.byType(PasswordResetStep), findsOneWidget);
      expect(find.text('forgetPassword.resetPassword'), findsOneWidget);
    },
  );

  testWidgets('ForgetPasswordView should show SnackBar on ShowSnackBarEvent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    const errorMessage = 'Test Error Message';
    navigationStreamController.add(ShowSnackBarEvent(errorMessage));
    await tester.pumpAndSettle(); // Wait for SnackBar animation

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets(
    'EmailVerificationStep should call doAction on Confirm button click',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      final confirmButton = find.byType(ElevatedButton);
      await tester.tap(confirmButton);
      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(1);
    },
  );
}
