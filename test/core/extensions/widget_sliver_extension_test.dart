import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/extensions/widget_sliver_extension.dart';

void main() {
  testWidgets('asSliver wraps widget in SliverToBoxAdapter', (
    WidgetTester tester,
  ) async {
    const text = Text('Hello Sliver');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(slivers: [text.asSliver]),
      ),
    );

    expect(find.byType(SliverToBoxAdapter), findsOneWidget);

    expect(find.text('Hello Sliver'), findsOneWidget);
  });
}
