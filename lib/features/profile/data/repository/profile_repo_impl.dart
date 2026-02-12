import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/data_source/profile_data_source.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/driver_dto.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/repository/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileDataSource _profileDataSource;
  ProfileRepoImpl(this._profileDataSource);
  @override
  Future<Result<DriverEntity>> getDriverData() async {
    final response = await _profileDataSource.getDriverData();

    switch (response) {
      case Success<DriverDataResponse>():
        {
          DriverDto driverDto = response.data.driverDto ?? DriverDto();
          DriverEntity driverEntity = driverDto.toEntity();
          return Success<DriverEntity>(driverEntity);
        }
      case Failure<DriverDataResponse>():
        return Failure<DriverEntity>(response.errorMessage);
    }
  }

  @override
  Future<Result<DriverEntity>> updateProfileData({
    required UpdateProfileRequest editProfileRequest,
  }) async {
    final response = await _profileDataSource.updateProfileData(
      editProfileRequest: editProfileRequest,
    );

    switch (response) {
      case Success<DriverDataResponse>():
        {
          DriverDto driverDto = response.data.driverDto ?? DriverDto();
          DriverEntity driverEntity = driverDto.toEntity();
          return Success<DriverEntity>(driverEntity);
        }
      case Failure<DriverDataResponse>():
        return Failure<DriverEntity>(response.errorMessage);
    }
  }

  @override
  Future<Result<UploadPhotoResponse>> uploadPhoto({
    required File imageFile,
  }) async {
    final multipart = await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.path.split('/').last,
    );
    final response = await _profileDataSource.uploadPhoto(photo: multipart);
    switch (response) {
      case Success<UploadPhotoResponse>():
        return Success(response.data);
      case Failure<UploadPhotoResponse>():
        return Failure(response.errorMessage);
    }
  }
}
