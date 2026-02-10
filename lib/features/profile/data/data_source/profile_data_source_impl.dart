import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/data_source/profile_data_source.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';

@Injectable(as: ProfileDataSource)
class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiClient _apiClient;
  ProfileDataSourceImpl(this._apiClient);

  @override
  Future<Result<DriverDataResponse>> getDriverData() {
    return executeApi(() async {
      final response = await _apiClient.getDriverData();
      return response;
    });
  }

  @override
  Future<Result<DriverDataResponse>> updateProfileData({
    required UpdateProfileRequest editProfileRequest,
  }) {
    return executeApi(() async {
      final response = await _apiClient.updateProfile(editProfileRequest);
      return response;
    });
  }
}
