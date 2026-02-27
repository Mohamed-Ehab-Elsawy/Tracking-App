import 'package:json_annotation/json_annotation.dart';

import 'orders_list_dto.dart';

part 'order_response_dto.g.dart';

@JsonSerializable()
class OrderResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final Metadata? metadata;
  @JsonKey(name: "orders")
  final List<OrdersListDto>? orders;

  OrderResponseDto({this.message, this.metadata, this.orders});

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    return _$OrderResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderResponseDtoToJson(this);
  }
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  final int? currentPage;
  @JsonKey(name: "totalPages")
  final int? totalPages;
  @JsonKey(name: "totalItems")
  final int? totalItems;
  @JsonKey(name: "limit")
  final int? limit;

  Metadata({this.currentPage, this.totalPages, this.totalItems, this.limit});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return _$MetadataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MetadataToJson(this);
  }
}
