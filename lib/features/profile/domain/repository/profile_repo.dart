import 'dart:io';

import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';

abstract class ProfileRepo {
  Future<Result<DriverEntity>> getDriverData();
  Future<Result<DriverEntity>> updateProfileData({
    required UpdateProfileRequest editProfileRequest,
  });
  Future<Result<UploadPhotoResponse>> uploadPhoto({required File imageFile});
}
