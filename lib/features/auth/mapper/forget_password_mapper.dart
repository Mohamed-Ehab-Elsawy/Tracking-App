import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';

extension VerificationCodeResponseDtoX on VerificationCodeResponseDto {
  VerificationCodeResponseEntity toEntity() {
    return VerificationCodeResponseEntity(status);
  }
}

extension ResetPasswordResponseDtoX on ResetPasswordResponseDto {
  ResetPasswordResponseEntity toEntity() {
    return ResetPasswordResponseEntity(message: message, token: token);
  }
}

extension EmailVerificationResponseDtoX on EmailVerificationResponseDto {
  EmailVerificationResponseEntity toEntity() {
    return EmailVerificationResponseEntity(into: into, message: message);
  }
}

extension UserEntityX on UserEntity {
  UserDto toDto() {
    return UserDto(email: email, code: code, password: password);
  }
}
