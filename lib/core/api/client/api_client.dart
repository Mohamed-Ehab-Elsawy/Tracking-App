import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET(ApiEndPointsConstants.login)
  Future<DriverLoginResponseDTO> login(@Body() DriverLoginRequestDTO request);
}
