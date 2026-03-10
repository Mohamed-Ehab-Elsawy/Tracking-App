import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';

part 'active_order_dto.g.dart';

@JsonSerializable()
class ActiveOrderDto {
  final String? orderId;
  final String? driverId;
  final String? userId;

  final String? driverToken;
  final String? userToken;

  final String? storeName;
  final String? storeAddress;
  final String? storeImage;

  final String? userName;
  final String? userImage;
  final String? userAddress;

  final double? totalPrice;

  final String? status;

  final DateTime? startedAt;
  final String? long;
  final String? lat;
  final String? city;
  final String? street;
  final String? phone;

  const ActiveOrderDto({
    this.orderId,
    this.driverId,
    this.userId,
    this.driverToken,
    this.userToken,
    this.storeName,
    this.storeAddress,
    this.storeImage,
    this.userName,
    this.userImage,
    this.userAddress,
    this.totalPrice,
    this.status,
    this.startedAt,
    this.long,
    this.lat,
    this.city,
    this.street,
    this.phone,
  });

  factory ActiveOrderDto.fromJson(Map<String, dynamic> json) =>
      _$ActiveOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveOrderDtoToJson(this);
  ActiveOrderEntity toEntity() {
    return ActiveOrderEntity(
      orderId: orderId ?? "",
      driverId: driverId ?? "",
      userId: userId ?? "",
      driverToken: driverToken ?? "",
      userToken: userToken ?? "",
      storeName: storeName ?? "",
      storeAddress: storeAddress ?? "",
      storeImage: storeImage ?? "",
      userName: userName ?? "",
      userImage: userImage ?? "",
      userAddress: userAddress ?? "",
      totalPrice: totalPrice ?? 0,
      status: status ?? "",
      startedAt: startedAt,
      long: long ?? "",
      lat: lat ?? "",
      city: city ?? "",
      street: street ?? "",
    );
  }
}
