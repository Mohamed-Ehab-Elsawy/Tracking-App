import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

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

  @POST(ApiEndPointsConstants.callFirebaseServer)
  Future<void> sendNotification({
    @Body() required SendNotificationRequest notificationDto,
    @Header(AppConstants.authorizationKey) required String authorization,
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
