import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/data/models/order_details_dto.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';

part 'active_order_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ActiveOrderDto extends Equatable {
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

  @JsonKey(fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime? startedAt;

  final double? long;
  final double? lat;

  final String? city;
  final String? street;
  final String? userPhoneNumber;

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
    this.userPhoneNumber,
    this.details,
  });

  double get storeLat => double.tryParse(storeLatLong?.split(',')[0] ?? '') ?? 0.0;
  double get storeLng => double.tryParse(storeLatLong?.split(',')[1] ?? '') ?? 0.0;

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
      storeLatLong: storeLatLong ?? "",
      storePhoneNumber: storePhoneNumber ?? "",
      userName: userName ?? "",
      userImage: userImage ?? "",
      userAddress: userAddress ?? "",
      totalPrice: totalPrice ?? 0,
      status: status ?? "",
      startedAt: startedAt,
      long: long.toString(),
      lat: lat.toString(),
      city: city ?? "",
      street: street ?? "",
      phone: storePhoneNumber ?? userPhoneNumber ?? "",
      details: details?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }

  static DateTime? _fromTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static dynamic _toTimestamp(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }

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
    storeLatLong,
    storePhoneNumber,
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
    userPhoneNumber,
    details,
  ];
}
