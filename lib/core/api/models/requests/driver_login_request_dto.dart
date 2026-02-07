import 'package:json_annotation/json_annotation.dart';

part 'driver_login_request_dto.g.dart';

@JsonSerializable()
class DriverLoginRequestDTO {
  final String email;
  final String password;

  DriverLoginRequestDTO(this.email, this.password);

  factory DriverLoginRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$DriverLoginRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLoginRequestDTOToJson(this);
}
