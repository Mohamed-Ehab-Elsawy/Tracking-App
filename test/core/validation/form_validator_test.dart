import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/validation/form_validator.dart';

void main() {
  group('FormValidators Unit Tests', () {
    group('username()', () {
      test('valid cases', () {
        expect(FormValidators.username('mohamed_ehab'), null);
        expect(FormValidators.username('user123'), null);
        expect(FormValidators.username('مستخدم'), null);
      });

      test('invalid cases', () {
        expect(FormValidators.username(null), 'validation.enterUsername');
        expect(FormValidators.username('ab'), 'validation.least3CharUsername');
        expect(
          FormValidators.username('user@name'),
          'validation.usernamePattern',
        );
      });
    });

    group('email()', () {
      final validEmails = ['dev@example.com', 'test.user@domain.co'];
      final invalidEmails = ['plain', 'me@', '@domain.com', 'me@domain'];

      for (final email in validEmails) {
        test(
          'should accept $email',
          () => expect(FormValidators.email(email), null),
        );
      }
      for (final email in invalidEmails) {
        test(
          'should reject $email',
          () => expect(FormValidators.email(email), 'validation.validEmail'),
        );
      }
    });

    group('password()', () {
      test('should accept valid password', () {
        expect(FormValidators.password('Flutter123!'), null);
      });

      test('should reject short passwords', () {
        expect(FormValidators.password('F1!'), 'validation.passwordCriteria');
      });

      test('should reject passwords missing criteria', () {
        expect(
          FormValidators.password('flutter123!'),
          'validation.passwordValidation',
        );
        expect(
          FormValidators.password('FLUTTER123!'),
          'validation.passwordValidation',
        );
        expect(
          FormValidators.password('Flutter!!!'),
          'validation.passwordValidation',
        );
        expect(
          FormValidators.password('Flutter123'),
          'validation.passwordValidation',
        );
      });
    });

    group('phoneNumber()', () {
      test('should accept valid E.164 with spaces', () {
        expect(FormValidators.phoneNumber('+20 123 456 7890'), null);
      });

      test('should reject local or missing +', () {
        expect(
          FormValidators.phoneNumber('0123456789'),
          'validation.validPhoneNumber',
        );
      });
    });

    group('confirmPassword()', () {
      test('should match', () {
        expect(FormValidators.confirmPassword('Pass1!', 'Pass1!'), null);
      });

      test('should mismatch', () {
        expect(
          FormValidators.confirmPassword('Pass1!', 'Wrong1!'),
          'validation.confirmPasswordNotMatch',
        );
      });
    });
  });
}
