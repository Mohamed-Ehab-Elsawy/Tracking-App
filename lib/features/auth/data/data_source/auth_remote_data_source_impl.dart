import 'dart:io';

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
    required File? nidImage,
    required File? vehicleLicense,
  }) async {
    final nidMultipart = await MultipartFile.fromFile(
      nidImage?.path ?? '',

      filename: nidImage?.path.split('/').last,
    );
    final vehicleLicenseMultipart = await MultipartFile.fromFile(
      vehicleLicense?.path ?? '',
      filename: vehicleLicense?.path.split('/').last,
    );
    return executeApi(
      () => apiClient.apply(
        applyRequest.country,
        applyRequest.firstName,
        applyRequest.lastName,
        applyRequest.vehicleType?.id,
        applyRequest.vehicleNumber,
        applyRequest.nID,
        applyRequest.email,
        applyRequest.password,
        applyRequest.rePassword,
        applyRequest.gender,
        applyRequest.phone,
        nidMultipart,
        vehicleLicenseMultipart,
      ),
    );
  }

  @override
  Future<Result<GetAllVehiclesResponse>> getAllVehicles() {
    return executeApi(() => apiClient.getAllVehicles());
  }
}
