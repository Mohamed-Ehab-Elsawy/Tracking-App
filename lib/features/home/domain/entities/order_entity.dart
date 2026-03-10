import 'package:tracking_app/features/home/data/models/store_dto.dart';

import '../../data/models/update_order_dto.dart';

class OrdersEntity {
  final String? id;
  final String? user;
  final List<OrderItems>? orderItems;
  final int? totalPrice;
  final ShippingAddress? shippingAddress;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final String? createdAt;
  final String? updatedAt;
  final String? orderNumber;
  final int? v;
  final StoreDto? store;

  OrdersEntity({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.shippingAddress,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
  });
}
