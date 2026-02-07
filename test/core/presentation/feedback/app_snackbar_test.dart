import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/light_theme.dart';

void main() {
  Widget buildTestableWidget(Widget body) {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(home: Scaffold(body: body)),
    );
  }

  testWidgets('AppSnackBar shows success message with correct color', (
    WidgetTester tester,
  ) async {
    const successMsg = 'Success!';

    await tester.pumpWidget(
      buildTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () =>
                  AppSnackBar.show(context, successMsg, isError: false),
              child: const Text('Show Success'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show Success'));
    await tester.pump();

    expect(find.text(successMsg), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    final BuildContext context = tester.element(find.byType(SnackBar));

    expect(snackBar.backgroundColor, context.colors.success);
  });

  testWidgets('AppSnackBar shows error message with error color', (
    WidgetTester tester,
  ) async {
    const errorMsg = 'Something went wrong';

    await tester.pumpWidget(
      buildTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () =>
                  AppSnackBar.show(context, errorMsg, isError: true),
              child: const Text('Show Error'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show Error'));
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    final BuildContext context = tester.element(find.byType(SnackBar));
    expect(snackBar.backgroundColor, context.colors.error);
  });

  testWidgets('AppSnackBar hides current snackbar before showing new one', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildTestableWidget(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => AppSnackBar.show(context, 'New SnackBar'),
              child: const Text('Trigger'),
            );
          },
        ),
      ),
    );

    AppSnackBar.show(tester.element(find.text('Trigger')), 'First');
    await tester.pump();
    expect(find.text('First'), findsOneWidget);

    await tester.tap(find.text('Trigger'));
    await tester.pump();

    expect(find.text('New SnackBar'), findsOneWidget);
  });
}
