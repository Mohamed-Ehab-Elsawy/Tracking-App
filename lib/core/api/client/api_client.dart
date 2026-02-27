import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/orders/data/models/response/order_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_response.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';

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
  @GET(ApiEndPointsConstants.getAllDriverOrders)
  Future<OrderResponseDto> getAllDriverOrders();

  @GET("${ApiEndPointsConstants.getSpecificProduct}/{id}")
  Future<ProductResponse> getProductDetails(@Path("id") String productId);

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

  @POST(ApiEndPointsConstants.apply)
  @MultiPart()
  Future<ApplyResponse> apply(
    @Part(name: "country") String? country,
    @Part(name: "firstName") String? firstName,
    @Part(name: "lastName") String? lastName,
    @Part(name: "vehicleType") String? vehicleType,
    @Part(name: "vehicleNumber") String? vehicleNumber,
    @Part(name: "NID") String? nid,
    @Part(name: "email") String? email,
    @Part(name: "password") String? password,
    @Part(name: "rePassword") String? rePassword,
    @Part(name: "gender") String? gender,
    @Part(name: "phone") String? phone,
    @Part(name: "NIDImg") MultipartFile? nidImages,
    @Part(name: "vehicleLicense") MultipartFile? vehicleLicense,
  );
  @GET(ApiEndPointsConstants.getAllVehicles)
  Future<GetAllVehiclesResponse> getAllVehicles();

  @POST(ApiEndPointsConstants.changePassword)
  Future<ChangePasswordResponse> changePassword({
    @Field("password") required String password,
    @Field("newPassword") required String newPassword,
  });
}
