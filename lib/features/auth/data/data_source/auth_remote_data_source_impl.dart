import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';

import 'auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Result<ApplyResponse>> apply(
    ApplyRequest applyRequest, {
    required MultipartFile? nidImage,
    required MultipartFile? vehicleLicense,
  }) {
    return executeApi(
      () => apiClient.apply(
        applyRequest.country,
        applyRequest.firstName,
        applyRequest.lastName,
        applyRequest.vehicleType?.type,
        applyRequest.vehicleNumber,
        applyRequest.nID,
        applyRequest.email,
        applyRequest.password,
        applyRequest.rePassword,
        applyRequest.gender,
        applyRequest.phone,
        nidImage,
        vehicleLicense,
      ),
    );
  }

  @override
  Future<Result<GetAllVehiclesResponse>> getAllVehicles() {
    return executeApi(() => apiClient.getAllVehicles());
  }
}
