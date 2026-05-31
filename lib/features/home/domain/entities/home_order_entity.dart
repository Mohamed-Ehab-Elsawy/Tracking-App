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
  final String? street;
  final String? city;
  final String? phone;
  final String? lat;
  final String? long;

  const HomeOrderEntity({
    this.orderId,
    this.storeName,
    this.storeAddress,
    this.storeImage,
    this.userName,
    this.totalPrice,
    this.userImage,
    this.status,
    this.userAddress,
    this.userId,
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
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
    street,
    city,
    phone,
    lat,
    long,
  ];
}

extension HomeOrderEntityX on HomeOrderEntity {
  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "storeName": storeName,
      "storeAddress": storeAddress,
      "storeImage": storeImage,
      "userName": userName,
      "userImage": userImage,
      "userAddress": userAddress,
      "totalPrice": totalPrice,
      "status": status,
      "userId": userId,
      "street": street,
      "city": city,
      "phone": phone,
      "lat": lat,
      "long": long,
    };
  }
}
