import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET(ApiEndPointsConstants.getProfile)
  Future<DriverDataResponse> getDriverData();
  @PUT(ApiEndPointsConstants.updateProfile)
  Future<DriverDataResponse> updateProfile(
    @Body() UpdateProfileRequest updateProfileRequest,
  );
  @PUT(ApiEndPointsConstants.uploadProfileImage)
  @MultiPart()
  Future<UploadPhotoResponse> uploadPhoto(
    @Part(name: 'photo') MultipartFile photo,
  );
}
