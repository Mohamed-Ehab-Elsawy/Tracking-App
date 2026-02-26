import 'package:dio/dio.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';

abstract class ProfileDataSource {
  Future<Result<DriverDataResponse>> getDriverData();
  Future<Result<DriverDataResponse>> updateProfileData({
    required UpdateProfileRequest editProfileRequest,
  });
  Future<Result<UploadPhotoResponse>> uploadPhoto({
    required MultipartFile photo,
  });
}
