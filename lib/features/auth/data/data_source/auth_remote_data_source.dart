import 'package:dio/dio.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<ApplyResponse>> apply(
    ApplyRequest applyRequest, {
    required MultipartFile? nidImage,
    required MultipartFile? vehicleLicense,
  });

  Future<Result<GetAllVehiclesResponse>> getAllVehicles();
}
