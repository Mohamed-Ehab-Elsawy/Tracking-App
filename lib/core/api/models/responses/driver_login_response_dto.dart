import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_login_response_dto.g.dart';

@JsonSerializable()
class DriverLoginResponseDTO with EquatableMixin {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  DriverLoginResponseDTO({this.message, this.token});

  factory DriverLoginResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$DriverLoginResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLoginResponseDTOToJson(this);

  @override
  List<Object?> get props => [message, token];
}
