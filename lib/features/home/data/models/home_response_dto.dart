import 'package:json_annotation/json_annotation.dart';

import 'meta_data_dto.dart';
import 'orders_dto.dart';

part 'home_response_dto.g.dart';

@JsonSerializable()
class HomeResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final MetadataDto? metadata;
  @JsonKey(name: "orders")
  final List<OrdersDto>? orders;

  HomeResponseDto({this.message, this.metadata, this.orders});

  factory HomeResponseDto.fromJson(Map<String, dynamic> json) {
    return _$HomeResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$HomeResponseDtoToJson(this);
  }
}
