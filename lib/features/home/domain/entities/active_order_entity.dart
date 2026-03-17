import 'package:equatable/equatable.dart';

class ActiveOrderEntity extends Equatable {
  final String orderId;
  final String driverId;
  final String userId;

  final String driverToken;
  final String userToken;

  final String storeName;
  final String storeAddress;
  final String storeImage;
  final String? storeLatLong;
  final String? storePhoneNumber;

  final String userName;
  final String userImage;
  final String userAddress;

  final double totalPrice;

  final String status;

  final DateTime? startedAt;

  final double? long;
  final double? lat;

  final String? city;
  final String? street;
  final String? phone;

  final List<OrderDetailsEntity> details;

  const ActiveOrderEntity({
    this.orderId = '',
    this.driverId = '',
    this.userId = '',
    this.driverToken = '',
    this.userToken = '',
    this.storeName = '',
    this.storeAddress = '',
    this.storeImage = '',
    this.storeLatLong,
    this.storePhoneNumber,
    this.userName = '',
    this.userImage = '',
    this.userAddress = '',
    this.totalPrice = 0,
    this.status = '',
    this.startedAt,
    this.long,
    this.lat,
    this.city,
    this.street,
    this.phone,
    this.details = const [],
  });

  @override
  List<Object?> get props => [
    orderId,
    driverId,
    userId,
    driverToken,
    userToken,
    storeName,
    storeAddress,
    storeImage,
    userName,
    userImage,
    userAddress,
    totalPrice,
    status,
    startedAt,
    long,
    lat,
    city,
    street,
    phone,
    details,
  ];
}

class OrderDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String price;
  final int count;

  const OrderDetailsEntity({
    this.id = '',
    this.title = '',
    this.price = '',
    this.count = 0,
  });

  @override
  List<Object?> get props => [id, title, price, count];
}