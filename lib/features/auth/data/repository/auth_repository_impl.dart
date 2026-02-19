import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    var response = await _authRemoteDataSource.changePassword(
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case Success<ChangePasswordResponse>():
        return Success<ChangePasswordResponse>(response.data);
      case Failure<ChangePasswordResponse>():
        return Failure<ChangePasswordResponse>(response.errorMessage);
    }
  }
}
