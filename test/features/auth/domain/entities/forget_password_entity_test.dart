import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';

void main() {
  group('forget password entity ...', () {
    test('test creational of EmailVerificationResponseEntity ', () {
      final result = EmailVerificationResponseEntity(
        message: 'message',
        into: 'into',
      );
      expect(result, isA<EmailVerificationResponseEntity>());
      expect(result.message, isA<String>());
      expect(result.into, isA<String>());
      expect(result.message, 'message');
      expect(result.into, 'into');
    });
    test('test creational of VerificationCodeResponseEntity ', () {
      final result = VerificationCodeResponseEntity('status');
      expect(result, isA<VerificationCodeResponseEntity>());
      expect(result.status, isA<String>());
      expect(result.status, 'status');
    });
    test('test creational of ResetPasswordResponseEntity ', () {
      final result = ResetPasswordResponseEntity(
        message: 'message',
        token: 'token',
      );
      expect(result, isA<ResetPasswordResponseEntity>());
      expect(result.message, isA<String>());
      expect(result.token, isA<String>());
      expect(result.message, 'message');
      expect(result.token, 'token');
    });

    test('test creational of UserEntity ', () {
      final result = UserEntity(
        email: 'email',
        code: 'code',
        password: 'password',
      );
      expect(result, isA<UserEntity>());
      expect(result.email, isA<String>());
      expect(result.code, isA<String>());
      expect(result.password, isA<String>());
      expect(result.email, 'email');
      expect(result.code, 'code');
      expect(result.password, 'password');
    });
  });
}
