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
  final String? storeLatLong;
  final String? storePhoneNumber;

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

  final List<OrderDetailsDto>? details;

  const ActiveOrderDto({
    this.orderId,
    this.driverId,
    this.userId,
    this.driverToken,
    this.userToken,
    this.storeName,
    this.storeAddress,
    this.storeImage,
    this.storeLatLong,
    this.storePhoneNumber,
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
    this.details,
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

      /// تحويل String → double
      long: double.tryParse(long ?? ''),
      lat: double.tryParse(lat ?? ''),

      city: city ?? "",
      street: street ?? "",

      /// توحيد phone
      phone: storePhoneNumber ?? phone ?? "",

      /// أهم نقطة: mapping list
      details: details
          ?.map((e) => e.toEntity())
          .toList() ??
          const [],
    );
  }
}

class OrderDetailsDto {
  final String id;
  final String title;
  final String price;
  final int count;

  const OrderDetailsDto(
      this.id,
      this.title,
      this.price,
      this.count,
      );

  factory OrderDetailsDto.fromMap(Map<String, dynamic> map) {
    return OrderDetailsDto(
      map['id'] ?? '',
      map['title'] ?? '',
      map['price'] ?? '',
      map['count'] ?? 0,
    );
  }

  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      id: id,
      title: title,
      price: price,
      count: count,
    );
  }
}