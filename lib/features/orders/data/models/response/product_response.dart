import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/orders/data/models/response/product_dto.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "product")
  final ProductDto? product;

  ProductResponse({this.message, this.product});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductResponseToJson(this);
  }
}
