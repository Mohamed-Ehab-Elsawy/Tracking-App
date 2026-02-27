import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/data/model/driver_dto.dart';

part 'driver_data_response.g.dart';

@JsonSerializable()
class DriverDataResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final DriverDto? driverDto;

  DriverDataResponse({this.message, this.driverDto});

  factory DriverDataResponse.fromJson(Map<String, dynamic> json) {
    return _$DriverDataResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverDataResponseToJson(this);
  }
}
