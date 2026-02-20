import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/mapper/forget_password_mapper.dart';

void main() {
  test(
    "test toEntity Methods should retern convert dto(VerificationCodeResponseDto) to Entity(VerificationCodeResponseEntity)",
    () {
      VerificationCodeResponseDto tDto = VerificationCodeResponseDto(
        status: "status",
      );
      var tEntity = tDto.toEntity();
      expect(tEntity.status, tDto.status);
      expect(tEntity, isA<VerificationCodeResponseEntity>());
    },
  );

  test(
    "test toEntity Methods should retern convert dto(ResetPasswordResponseDto) to Entity(ResetPasswordResponseEntity)",
    () {
      ResetPasswordResponseDto tDto = ResetPasswordResponseDto(
        message: "message",
        token: "token",
      );
      var tEntity = tDto.toEntity();
      expect(tEntity.message, tDto.message);
      expect(tEntity.token, tDto.token);
      expect(tEntity, isA<ResetPasswordResponseEntity>());
    },
  );

  test(
    "test toEntity Methods should retern convert dto(EmailVerificationResponseDto) to Entity(EmailVerificationResponseEntity)",
    () {
      EmailVerificationResponseDto tDto = EmailVerificationResponseDto(
        message: "message",
        into: "into",
      );
      var tEntity = tDto.toEntity();
      expect(tEntity.message, tDto.message);
      expect(tEntity.into, tDto.into);
      expect(tEntity, isA<EmailVerificationResponseEntity>());
    },
  );

  test(
    "test toDto Methods should retern convert entity(user) and dto(user)",
    () {
      UserEntity tEntity = UserEntity(
        email: "email",
        code: "code",
        password: "password",
      );
      var tDto = tEntity.toDto();
      expect(tDto.email, tEntity.email);
      expect(tDto.code, tEntity.code);
      expect(tDto.password, tEntity.password);
      expect(tDto, isA<UserDto>());
    },
  );
}
