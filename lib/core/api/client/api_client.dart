import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/api/utils/api_end_points_constants.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

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
}
