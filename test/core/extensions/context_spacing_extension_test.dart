import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';

void main() {
  Widget buildTestApp({required Size screenSize, required Widget child}) {
    return MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(body: child);
          },
        ),
      ),
    );
  }

  testWidgets('h() returns SizedBox with correct responsive height', (
    tester,
  ) async {
    const screenSize = Size(375, 812);

    await tester.pumpWidget(
      buildTestApp(
        screenSize: screenSize,
        child: Builder(builder: (context) => context.h(100)),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.height, 100);
  });

  testWidgets('w() returns SizedBox with correct responsive width', (
    tester,
  ) async {
    const screenSize = Size(375, 812); // iPhone X baseline

    await tester.pumpWidget(
      buildTestApp(
        screenSize: screenSize,
        child: Builder(builder: (context) => context.w(50)),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, 50);
  });

  testWidgets('h() scales correctly on larger screen', (tester) async {
    const screenSize = Size(375, 1000);

    await tester.pumpWidget(
      buildTestApp(
        screenSize: screenSize,
        child: Builder(builder: (context) => context.h(100)),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.height, closeTo(123.15, 0.01)); // 100 * (1000 / 812)
  });

  testWidgets('w() scales correctly on larger screen', (tester) async {
    const screenSize = Size(500, 812);

    await tester.pumpWidget(
      buildTestApp(
        screenSize: screenSize,
        child: Builder(builder: (context) => context.w(100)),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.width, closeTo(133.33, 0.01)); // 100 * (500 / 375)
  });
}
