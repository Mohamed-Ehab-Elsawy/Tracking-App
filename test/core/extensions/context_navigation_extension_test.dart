import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extensions/context_navigation_extension.dart';

void main() {
  late BuildContext testContext;

  Widget buildTestApp() {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) {
          testContext = context;
          return const Scaffold(body: Text('Home'));
        },
        '/second': (_) => const Scaffold(body: Text('Second')),
        '/third': (_) => const Scaffold(body: Text('Third')),
      },
    );
  }

  testWidgets('pushNamed navigates to new route', (tester) async {
    await tester.pumpWidget(buildTestApp());

    testContext.pushNamed('/second');
    await tester.pumpAndSettle();

    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('pop removes current route', (tester) async {
    await tester.pumpWidget(buildTestApp());

    testContext.pushNamed('/second');
    await tester.pumpAndSettle();

    testContext.pop();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('pushNamedAndRemoveUntil removes all previous routes', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    testContext.pushNamed('/second');
    await tester.pumpAndSettle();

    testContext.pushNamedAndRemoveUntil('/third');
    await tester.pumpAndSettle();

    expect(find.text('Third'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Second'), findsNothing);
  });

  testWidgets('pushReplacementNamed replaces current route', (tester) async {
    await tester.pumpWidget(buildTestApp());

    testContext.pushNamed('/second');
    await tester.pumpAndSettle();

    testContext.pushReplacementNamed('/third');
    await tester.pumpAndSettle();

    expect(find.text('Third'), findsOneWidget);
    expect(find.text('Second'), findsNothing);
  });
}
