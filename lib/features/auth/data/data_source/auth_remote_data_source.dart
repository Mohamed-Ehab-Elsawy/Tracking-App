import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<String>> login(String email, String password);


  Future<Result<EmailVerificationResponseDto>> emailVerification(UserDto user);

  Future<Result<VerificationCodeResponseDto>> codeVerification(UserDto user);

  Future<Result<ResetPasswordResponseDto>> resetPassword(UserDto user);
}
