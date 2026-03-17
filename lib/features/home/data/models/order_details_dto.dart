import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';

part 'order_details_dto.g.dart';

@JsonSerializable()
class OrderDetailsDto {
  final String id;
  final String title;
  final String price;
  final int count;

  const OrderDetailsDto({
    required this.id,
    required this.title,
    required this.price,
    required this.count,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsDtoToJson(this);

  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(id: id, title: title, price: price, count: count);
  }
}
