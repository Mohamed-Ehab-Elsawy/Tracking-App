import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

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
      key: AppConstants.userTokenKey,
      value: token,
    );
  }
}
