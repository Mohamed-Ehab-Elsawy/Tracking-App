import 'package:tracking_app/features/order_details/domain/entities/order_details_entity.dart';

class OrderEntity {
  String id;
  String status;
  String createdAt;
  String storeName, storeAddress, storePhone;
  String userName, userAddress, userPhone;
  List<OrderDetailsEntity> details;
  String paymentMethod;

  OrderEntity({
    this.id = "",
    this.status = "",
    this.createdAt = "",
    this.storeName = "",
    this.storeAddress = "",
    this.storePhone = "",
    this.userName = "",
    this.userAddress = "",
    this.userPhone = "",
    this.details = const [],
    this.paymentMethod = "",
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) => OrderEntity(
    id: map['id'] ?? '',
    status: map['status'] ?? '',
    createdAt: map['createdAt'] ?? '',
    storeName: map['storeName'] ?? '',
    storeAddress: map['storeAddress'] ?? '',
    storePhone: map['storePhone'] ?? '',
    userName: map['userName'] ?? '',
    userAddress: map['userAddress'] ?? '',
    userPhone: map['userPhone'] ?? '',
    paymentMethod: map['paymentMethod'] ?? '',
    details: (map['details'] as List<dynamic>? ?? [])
        .map((e) => OrderDetailsEntity.fromMap(e as Map<String, dynamic>))
        .toList(),
  );
}
