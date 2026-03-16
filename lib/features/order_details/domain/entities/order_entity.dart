import 'package:tracking_app/features/order_details/domain/entities/order_details_entity.dart';

class OrderEntity {
  String id;
  String status;
  String startedAt;
  String storeName, storeAddress, storePhone, storeImage;
  String userId, userName, userAddress, userPhone, userImage, userToken;
  String driverId, driverToken;
  String lat, long;
  List<OrderDetailsEntity> details;
  String paymentMethod;
  String street, city;

  OrderEntity({
    this.id = "",
    this.status = "",
    this.startedAt = "",
    this.storeName = "",
    this.storeAddress = "",
    this.storePhone = "",
    this.userName = "",
    this.userAddress = "",
    this.userPhone = "",
    this.details = const [],
    this.paymentMethod = "",
    this.street = "",
    this.city = "",
    this.storeImage = "",
    this.userImage = "",
    this.lat = "",
    this.long = "",
    this.driverId = "",
    this.driverToken = "",
    this.userId = "",
    this.userToken = "",
  });

  factory OrderEntity.fromMap(Map<String, dynamic> map) => OrderEntity(
    id: map['id'] ?? '',
    status: map['status'] ?? '',
    startedAt: map['createdAt'] ?? '',
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
    street: map['street'] ?? '',
    city: map['city'] ?? '',
    storeImage: map['storeImage'] ?? '',
    userImage: map['userImage'] ?? '',
    lat: map['lat'] ?? '',
    long: map['long'] ?? '',
    driverId: map['driverId'] ?? '',
    driverToken: map['driverToken'] ?? '',
    userId: map['userId'] ?? '',
    userToken: map['userToken'] ?? '',
  );
}
