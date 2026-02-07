import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/presentation/feedback/app_dialog.dart';
import 'package:tracking_app/core/presentation/feedback/model/app_dialog_action.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';

void main() {
  Widget buildTestableWidget(Function(BuildContext context) onPress) {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => onPress.call(context),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('AppDialog should not render icon or spacing when icon is null', (
    WidgetTester tester,
  ) async {
    void onPress(BuildContext context) {
      AppDialog.show(
        context,
        title: 'No Icon Title',
        message: 'No Icon Message',
        icon: null, // Explicitly null
      );
    }

    await tester.pumpWidget(buildTestableWidget(onPress));
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    expect(find.byType(Icon), findsNothing);
    // Verifying the title is still there
    expect(find.text('No Icon Title'), findsOneWidget);
  });

  testWidgets('AppDialog should render outlined action and handle tap', (
    WidgetTester tester,
  ) async {
    bool outlinedTapped = false;

    void onPress(BuildContext context) {
      AppDialog.show(
        context,
        title: 'Outlined Test',
        message: 'Testing outlined button',
        actions: [
          AppDialogAction.outlined(
            label: 'Dismiss',
            onPressed: () => outlinedTapped = true,
          ),
        ],
      );
    }

    await tester.pumpWidget(buildTestableWidget(onPress));
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    final outlinedFinder = find.text('Dismiss');
    expect(outlinedFinder, findsOneWidget);

    await tester.tap(outlinedFinder);
    expect(outlinedTapped, isTrue);
  });

  testWidgets(
    'AppDialog should close on barrier tap when barrierDismissible is true',
    (WidgetTester tester) async {
      void onPress(BuildContext context) {
        AppDialog.show(
          context,
          title: 'Dismissible Dialog',
          message: 'Tap outside to close',
          barrierDismissible: true,
        );
      }

      await tester.pumpWidget(buildTestableWidget(onPress));
      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Verify it's open
      expect(find.text('Dismissible Dialog'), findsOneWidget);

      // Tap the top-left corner (the barrier)
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      // Verify it's closed
      expect(find.text('Dismissible Dialog'), findsNothing);
    },
  );
}
