import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);
  @override
  Future<Result<ResetPasswordResponseDto>> resetPassword(UserDto user) =>
      executeApi(() async {
        return _apiClient.resetPassword(userDto: user);
      });
  @override
  Future<Result<EmailVerificationResponseDto>> emailVerification(
    UserDto user,
  ) => executeApi(() async {
    return _apiClient.emailVerification(userDto: user);
  });

  @override
  Future<Result<VerificationCodeResponseDto>> codeVerification(UserDto user) =>
      executeApi(() async {
        return _apiClient.verifyResetPasswordCode(userDto: user);
      });
}
