import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';

import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  }) {
    return executeApi(
      () => _apiClient.changePassword(
        password: password,
        newPassword: newPassword,
      ),
    );
  }
}
