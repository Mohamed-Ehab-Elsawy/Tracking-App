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

  final String userName;
  final String userImage;
  final String userAddress;

  final double totalPrice;

  final String status;

  final DateTime? startedAt;
  final String? long;
  final String? lat;
  final String? city;
  final String? street;
  final String? phone;

  const ActiveOrderEntity({
    this.orderId = '',
    this.driverId = '',
    this.userId = '',
    this.driverToken = '',
    this.userToken = '',
    this.storeName = '',
    this.storeAddress = '',
    this.storeImage = '',
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
  ];
}
