import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/data/models/update_order_dto.dart';

part 'update_order_response.g.dart';

@JsonSerializable()
class UpdateOrderResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "orders")
  final UpdateOrdersDto? orders;

  UpdateOrderResponse({this.message, this.orders});

  factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) {
    return _$UpdateOrderResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateOrderResponseToJson(this);
  }
}
