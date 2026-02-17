import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

void main() {
  group('EmailVerificationResponseDto', () {
    const mockMessage = "Success";
    const mockInfo = "Verification email sent";
    const mockJson = {"message": mockMessage, "info": mockInfo};

    test('should support value equality', () {
      expect(
        const EmailVerificationResponseDto(
          message: mockMessage,
          into: mockInfo,
        ),
        const EmailVerificationResponseDto(
          message: mockMessage,
          into: mockInfo,
        ),
      );
    });

    test('fromJson should return a valid model', () {
      final result = EmailVerificationResponseDto.fromJson(mockJson);

      expect(result, isA<EmailVerificationResponseDto>());
      expect(result.message, mockMessage);
      expect(result.into, mockInfo);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = EmailVerificationResponseDto(
        message: mockMessage,
        into: mockInfo,
      );
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('props should contain message and into', () {
      const dto = EmailVerificationResponseDto(
        message: mockMessage,
        into: mockInfo,
      );
      expect(dto.props, [mockMessage, mockInfo]);
    });
  });

  group('VerificationCodeResponseDto', () {
    const mockStatus = "Success";
    const mockJson = {"status": mockStatus};

    test('should support value equality', () {
      expect(
        const VerificationCodeResponseDto(status: mockStatus),
        const VerificationCodeResponseDto(status: mockStatus),
      );
    });

    test('fromJson should return a valid model', () {
      final result = VerificationCodeResponseDto.fromJson(mockJson);

      expect(result, isA<VerificationCodeResponseDto>());
      expect(result.status, mockStatus);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = VerificationCodeResponseDto(status: mockStatus);
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('props should contain status', () {
      const dto = VerificationCodeResponseDto(status: mockStatus);
      expect(dto.props, [mockStatus]);
    });
  });

  group('ResetPasswordResponseDto', () {
    const mockMessage = "Success";
    const mockToken = "some-token";
    const mockJson = {"message": mockMessage, "token": mockToken};

    test('should support value equality', () {
      expect(
        const ResetPasswordResponseDto(message: mockMessage, token: mockToken),
        const ResetPasswordResponseDto(message: mockMessage, token: mockToken),
      );
    });

    test('fromJson should return a valid model', () {
      final result = ResetPasswordResponseDto.fromJson(mockJson);

      expect(result, isA<ResetPasswordResponseDto>());
      expect(result.message, mockMessage);
      expect(result.token, mockToken);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = ResetPasswordResponseDto(
        message: mockMessage,
        token: mockToken,
      );
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('props should contain message and token', () {
      const dto = ResetPasswordResponseDto(
        message: mockMessage,
        token: mockToken,
      );
      expect(dto.props, [mockMessage, mockToken]);
    });
  });

  group('UserDto', () {
    const mockEmail = "test@example.com";
    const mockCode = "123456";
    const mockPassword = "password123";
    const mockJson = {
      "email": mockEmail,
      "resetCode": mockCode,
      "newPassword": mockPassword,
    };

    test('should support value equality', () {
      expect(
        const UserDto(email: mockEmail, code: mockCode, password: mockPassword),
        const UserDto(email: mockEmail, code: mockCode, password: mockPassword),
      );
    });

    test('fromJson should return a valid model', () {
      final result = UserDto.fromJson(mockJson);

      expect(result, isA<UserDto>());
      expect(result.email, mockEmail);
      expect(result.code, mockCode);
      expect(result.password, mockPassword);
    });

    test('toJson should return a JSON map containing proper data', () {
      const dto = UserDto(
        email: mockEmail,
        code: mockCode,
        password: mockPassword,
      );
      final result = dto.toJson();

      expect(result, mockJson);
    });

    test('toJson should not include null values', () {
      const dto = UserDto(email: mockEmail);
      final result = dto.toJson();

      expect(result, {"email": mockEmail});
      expect(result.containsKey('resetCode'), false);
      expect(result.containsKey('newPassword'), false);
    });

    test('props should contain email, code, and password', () {
      const dto = UserDto(
        email: mockEmail,
        code: mockCode,
        password: mockPassword,
      );
      expect(dto.props, [mockEmail, mockCode, mockPassword]);
    });
  });
}
