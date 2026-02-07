import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/presentation/feedback/model/app_dialog_action.dart';

void main() {
  group('AppDialogAction Equality & Factory Tests', () {
    void mockCallback() {}
    void anotherCallback() {}

    test('should be equal when all properties are identical', () {
      final action1 = AppDialogAction.primary(
        label: 'Submit',
        onPressed: mockCallback,
      );
      final action2 = AppDialogAction.primary(
        label: 'Submit',
        onPressed: mockCallback,
      );

      expect(action1, equals(action2));
      expect(action1.hashCode, equals(action2.hashCode));
    });

    test('should NOT be equal when labels differ', () {
      final action1 = AppDialogAction.primary(
        label: 'A',
        onPressed: mockCallback,
      );
      final action2 = AppDialogAction.primary(
        label: 'B',
        onPressed: mockCallback,
      );

      expect(action1, isNot(equals(action2)));
    });

    test('should NOT be equal when styles (isPrimary) differ', () {
      final action1 = AppDialogAction.primary(
        label: 'Save',
        onPressed: mockCallback,
      );
      final action2 = AppDialogAction.outlined(
        label: 'Save',
        onPressed: mockCallback,
      );

      expect(action1, isNot(equals(action2)));
    });

    test('should NOT be equal when callbacks differ', () {
      final action1 = AppDialogAction.primary(
        label: 'Back',
        onPressed: mockCallback,
      );
      final action2 = AppDialogAction.primary(
        label: 'Back',
        onPressed: anotherCallback,
      );

      expect(action1, isNot(equals(action2)));
    });

    test('factory primary should set correct flags', () {
      final action = AppDialogAction.primary(
        label: 'Ok',
        onPressed: mockCallback,
      );
      expect(action.isPrimary, isTrue);
    });

    test('factory outlined should set correct flags', () {
      final action = AppDialogAction.outlined(
        label: 'Cancel',
        onPressed: mockCallback,
      );
      expect(action.isPrimary, isFalse);
    });
  });
}
