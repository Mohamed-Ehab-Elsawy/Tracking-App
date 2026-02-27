import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';

abstract interface class AuthRepository {
  Future<Result<String>> login(String email, String password, bool rememberMe);
  Future<Result<EmailVerificationResponseEntity>> sendResetPasswordCode(
    UserEntity user,
  );

  Future<Result<VerificationCodeResponseEntity>> verifyResetPasswordCode(
    UserEntity user,
  );
  Future<Result<ResetPasswordResponseEntity>> resetPassword(UserEntity user);
}
