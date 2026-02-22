import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET(ApiEndPointsConstants.orders)
  Future<HomeResponseDto> getOrders(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
