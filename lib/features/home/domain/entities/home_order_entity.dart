import 'package:equatable/equatable.dart';

class HomeOrderEntity extends Equatable {
  final String? orderId;
  final String? storeName;
  final String? storeAddress;
  final String? storeImage;
  final String? userName;
  final String? userImage;
  final String? userAddress;
  final double? totalPrice;

  final String? status;
  final String? userId;

  const HomeOrderEntity({
    required this.orderId,
    required this.storeName,
    required this.storeAddress,
    required this.storeImage,
    required this.userName,
    required this.totalPrice,
    required this.userImage,
    required this.status,
    required this.userAddress,
    this.userId,
  });

  @override
  List<Object?> get props => [
    orderId,
    storeName,
    storeAddress,
    storeImage,
    userName,
    totalPrice,
    status,
    userId,
    userImage,
    userAddress,
  ];
}
