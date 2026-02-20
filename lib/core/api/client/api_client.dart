import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';

import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST(ApiEndPointsConstants.login)
  Future<DriverLoginResponseDTO> login(@Body() DriverLoginRequestDTO request);

  @POST(ApiEndPointsConstants.forgetPassword)
  Future<EmailVerificationResponseDto> emailVerification({
    @Body() required UserDto userDto,
  });

  @POST(ApiEndPointsConstants.verifyOtp)
  Future<VerificationCodeResponseDto> verifyResetPasswordCode({
    @Body() required UserDto userDto,
  });

  @PUT(ApiEndPointsConstants.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword({
    @Body() required UserDto userDto,
  });

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
