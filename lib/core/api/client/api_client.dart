import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/orders/data/models/response/order_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_response.dart';

import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
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
  @GET(ApiEndPointsConstants.getAllDriverOrders)
  Future<OrderResponseDto> getAllDriverOrders();

  @GET("${ApiEndPointsConstants.getSpecificProduct}/{id}")
  Future<ProductResponse> getProductDetails(@Path("id") String productId);
}
