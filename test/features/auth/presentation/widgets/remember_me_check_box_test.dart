import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/presentation/widgets/remember_me_check_box.dart';

void main() {
  Widget buildTestableWidget({Function(bool?)? onCheck}) => MaterialApp(
    home: Scaffold(
      body: RememberMeCheckBox(
        isCheck: (value) {
          onCheck?.call(value);
        },
      ),
    ),
  );

  group('RememberMeCheckBox Tests', () {
    testWidgets(
      'should initialize with unchecked state and display correct text',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildTestableWidget());

        // Assert
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isFalse);
        expect(find.byType(Text), findsOneWidget);
      },
    );

    testWidgets('should toggle state and trigger callback when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool? capturedValue;
      await tester.pumpWidget(
        buildTestableWidget(
          onCheck: (value) {
            capturedValue = value;
          },
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
      expect(capturedValue, isTrue);

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      final checkboxUnchecked = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkboxUnchecked.value, isFalse);
      expect(capturedValue, isFalse);
    });
  });
}
