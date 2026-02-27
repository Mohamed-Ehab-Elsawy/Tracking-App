import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/model/response/metadata.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';

part 'get_all_vehicles_response.g.dart';

@JsonSerializable()
class GetAllVehiclesResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final Metadata? metadata;
  @JsonKey(name: "vehicles")
  final List<Vehicles>? vehicles;

  GetAllVehiclesResponse({this.message, this.metadata, this.vehicles});

  factory GetAllVehiclesResponse.fromJson(Map<String, dynamic> json) {
    return _$GetAllVehiclesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetAllVehiclesResponseToJson(this);
  }
}
