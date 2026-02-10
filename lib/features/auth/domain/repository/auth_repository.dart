import 'package:dio/dio.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';

abstract interface class AuthRepository {
  Future<Result<ApplyResponseEntity>> apply(
    DriverEntity applyEntity, {
    MultipartFile? nidImage,
    MultipartFile? vehicleLicense,
  });
}
