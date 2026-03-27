import 'package:json_annotation/json_annotation.dart';

part 'update_order_state_request.g.dart';

@JsonSerializable()
class UpdateOrderStateRequest {
  @JsonKey(name: "state")
  final String? state;

  UpdateOrderStateRequest ({
    this.state,
  });

  factory UpdateOrderStateRequest.fromJson(Map<String, dynamic> json) {
    return _$UpdateOrderStateRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateOrderStateRequestToJson(this);
  }
}


