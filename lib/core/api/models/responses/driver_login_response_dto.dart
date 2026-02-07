import 'package:json_annotation/json_annotation.dart';

part 'driver_login_response_dto.g.dart';

@JsonSerializable()
class DriverLoginResponseDTO {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  DriverLoginResponseDTO({this.message, this.token});

  factory DriverLoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return _$DriverLoginResponseDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverLoginResponseDTOToJson(this);
  }
}
