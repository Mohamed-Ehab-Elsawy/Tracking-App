import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';
import 'package:tracking_app/features/auth/presentation/widgets/custom_text_form_field.dart';

void main() {
  Widget buildTestableWidget({
    required TextInputType keyboardType,
    required Function(String value) onTextChange,
    FormFieldValidator<String>? validator,
    GlobalKey<FormState>? formKey,
  }) => AppThemeProvider(
    appTheme: LightTheme(),
    child: MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: CustomTextFormField(
            keyboardType: keyboardType,
            onTextChange: onTextChange,
            hint: 'Enter text',
            label: 'Label',
            validator: validator,
          ),
        ),
      ),
    ),
  );

  group("CustomTextFormField Tests", () {
    testWidgets("should call onTextChange when text is entered", (
      WidgetTester tester,
    ) async {
      // Arrange
      String capturedText = '';
      await tester.pumpWidget(
        buildTestableWidget(
          keyboardType: TextInputType.text,
          onTextChange: (value) {
            capturedText = value;
          },
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'Hello World!');

      // Assert
      expect(capturedText, 'Hello World!');
      expect(find.text('Enter text'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets(
      "should toggle password visibility when suffix icon is tapped",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildTestableWidget(
            keyboardType: TextInputType.visiblePassword,
            onTextChange: (_) {},
          ),
        );

        Finder textFieldFinder = find.byType(TextField);
        TextField textField = tester.widget<TextField>(textFieldFinder);

        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.remove_red_eye_rounded), findsOneWidget);

        // Act
        await tester.tap(find.byType(InkWell));
        await tester.pump();

        textField = tester.widget<TextField>(textFieldFinder);
        // Assert
        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.disabled_visible_rounded), findsOneWidget);
      },
    );

    testWidgets("should trigger validation error when validator is provided", (
      WidgetTester tester,
    ) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        buildTestableWidget(
          keyboardType: TextInputType.text,
          onTextChange: (_) {},
          validator: (value) => 'Error',
          formKey: formKey,
        ),
      );

      // Act
      formKey.currentState?.validate();
      await tester.pump();

      // Assert
      expect(find.text('Error'), findsOneWidget);
    });
  });
}
