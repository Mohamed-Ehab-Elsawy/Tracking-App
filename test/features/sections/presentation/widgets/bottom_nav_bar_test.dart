import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/sections/presentation/widgets/bottom_nav_bar.dart';

void main() {
  Widget buildTestableWidget({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  group('BottomNavBar Widget Tests', () {
    testWidgets('renders all navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(currentIndex: 0, onTap: (_) {}),
      );

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.fact_check_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('displays the correct active tab index', (
      WidgetTester tester,
    ) async {
      const activeIndex = 1;

      await tester.pumpWidget(
        buildTestableWidget(currentIndex: activeIndex, onTap: (_) {}),
      );

      final BottomNavigationBar navBar = tester.widget(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, activeIndex);
    });

    testWidgets('calls onTap with correct index when an item is pressed', (
      WidgetTester tester,
    ) async {
      int? capturedIndex;

      await tester.pumpWidget(
        buildTestableWidget(
          currentIndex: 0,
          onTap: (index) => capturedIndex = index,
        ),
      );

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();

      expect(capturedIndex, 2);
    });
  });
}
