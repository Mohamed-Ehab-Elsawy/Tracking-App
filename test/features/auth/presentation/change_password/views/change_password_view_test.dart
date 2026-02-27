import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/constants/keys_constants.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/change_password/views/change_password_view.dart';

import 'change_password_view_test.mocks.dart';

@GenerateMocks([ChangePasswordViewModel])
void main() {
  late MockChangePasswordViewModel mockViewModel;

  setUp(() async {
    mockViewModel = MockChangePasswordViewModel();
    when(mockViewModel.uiEventsStream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ChangePasswordViewModel>.value(
        value: mockViewModel,
        child: const ChangePasswordView(),
      ),
    );
  }

  group("ChangePasswordView Widget Test", () {
    testWidgets("Initial UI renders correctly", (WidgetTester tester) async {
      when(mockViewModel.state).thenReturn(ChangePasswordState.initial());
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byKey(Key(KeysConstants.updatePasswordKey)), findsOneWidget);
    });

    testWidgets("Shows loading indicator when state is loading", (
      WidgetTester tester,
    ) async {
      final loadingState = ChangePasswordState(
        changePasswordState: BaseState.loading(),
      );

      when(mockViewModel.state).thenReturn(loadingState);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(loadingState));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Calls doIntent when button tapped", (
      WidgetTester tester,
    ) async {
      when(mockViewModel.state).thenReturn(ChangePasswordState.initial());
      when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), "Mohamed@123");
      await tester.enterText(find.byType(TextFormField).at(1), "Mohamed@1234");
      await tester.tap(find.byKey(Key(KeysConstants.updatePasswordKey)));
      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(1);
    });

    testWidgets("Shows success state correctly", (WidgetTester tester) async {
      final successState = ChangePasswordState(
        changePasswordState: BaseState.loaded(
          ChangePasswordResponse(message: "Password changed successfully"),
        ),
      );

      when(mockViewModel.state).thenReturn(successState);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(successState));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(Key(KeysConstants.updatePasswordKey)), findsOneWidget);
    });
    testWidgets("Shows error state correctly", (WidgetTester tester) async {
      final errorState = ChangePasswordState(
        changePasswordState: BaseState.error("Something went wrong"),
      );

      when(mockViewModel.state).thenReturn(errorState);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(errorState));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
