import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/mapper/forget_password_mapper.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Result<String>> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    var result = await _authRemoteDataSource.login(email, password);
    switch (result) {
      case Success<String>():
        if (rememberMe) await _storeTokenAndRememberMe(result.data);
        return Success('logged_in_successfully');
      case Failure<String>():
        return result;
    }
  }

  Future<void> _storeTokenAndRememberMe(String token) async {
    await AppLocalStorage.set(AppConstants.rememberMeKey, true);
    await AppLocalStorage.setSecuredString(
      key: AppConstants.userToken,
      value: token,
    );
  }

  @override
  Future<Result<ResetPasswordResponseEntity>> resetPassword(
    UserEntity user,
  ) async {
    final result = await _authRemoteDataSource.resetPassword(user.toDto());
    switch (result) {
      case Success<ResetPasswordResponseDto>():
        return Success(result.data.toEntity());
      case Failure<ResetPasswordResponseDto>():
        return Failure(result.errorMessage);
    }
  }

  @override
  Future<Result<EmailVerificationResponseEntity>> sendResetPasswordCode(
    UserEntity user,
  ) async {
    final result = await _authRemoteDataSource.emailVerification(user.toDto());
    switch (result) {
      case Success<EmailVerificationResponseDto>():
        return Success(result.data.toEntity());
      case Failure<EmailVerificationResponseDto>():
        return Failure(result.errorMessage);
    }
  }

  @override
  Future<Result<VerificationCodeResponseEntity>> verifyResetPasswordCode(
    UserEntity user,
  ) async {
    final result = await _authRemoteDataSource.codeVerification(user.toDto());
    switch (result) {
      case Success<VerificationCodeResponseDto>():
        return Success(result.data.toEntity());
      case Failure<VerificationCodeResponseDto>():
        return Failure(result.errorMessage);
    }
  }
}
