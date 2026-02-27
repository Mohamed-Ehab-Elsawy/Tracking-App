import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';

class OrdersListEntity {
  final String? id;
  final String? driver;
  final OrderDto? order;
  final int? v;
  final String? createdAt;
  final String? updatedAt;
  final Store? store;

  OrdersListEntity({
    this.id,
    this.driver,
    this.order,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.store,
  });
}
