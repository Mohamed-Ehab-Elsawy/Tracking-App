import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/data/models/store_dto.dart';
import 'package:tracking_app/features/home/domain/entities/order_entity.dart';
part 'update_order_dto.g.dart';

@JsonSerializable()
class UpdateOrdersDto {
  @JsonKey(name: "shippingAddress")
  final ShippingAddress? shippingAddress;
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "user")
  final String? user;
  @JsonKey(name: "orderItems")
  final List<OrderItems>? orderItems;
  @JsonKey(name: "totalPrice")
  final int? totalPrice;
  @JsonKey(name: "paymentType")
  final String? paymentType;
  @JsonKey(name: "isPaid")
  final bool? isPaid;
  @JsonKey(name: "paidAt")
  final String? paidAt;
  @JsonKey(name: "isDelivered")
  final bool? isDelivered;
  @JsonKey(name: "state")
  final String? state;
  @JsonKey(name: "createdAt")
  final String? createdAt;
  @JsonKey(name: "updatedAt")
  final String? updatedAt;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "__v")
  final int? v;
  @JsonKey(name: "store")
  final StoreDto? store;

  UpdateOrdersDto({
    this.shippingAddress,
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.paidAt,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
  });

  factory UpdateOrdersDto.fromJson(Map<String, dynamic> json) {
    return _$UpdateOrdersDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateOrdersDtoToJson(this);
  }

  OrdersEntity toEntity() {
    return OrdersEntity(
      id: id,
      user: user,
      orderItems: orderItems,
      totalPrice: totalPrice,
      shippingAddress: shippingAddress,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderNumber: orderNumber,
      v: v,
      store: store,
    );
  }
}

@JsonSerializable()
class ShippingAddress {
  @JsonKey(name: "street")
  final String? street;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "lat")
  final String? lat;
  @JsonKey(name: "long")
  final String? long;

  ShippingAddress({this.street, this.city, this.phone, this.lat, this.long});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return _$ShippingAddressFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ShippingAddressToJson(this);
  }
}

@JsonSerializable()
class OrderItems {
  @JsonKey(name: "product")
  final String? product;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "_id")
  final String? idd;

  OrderItems({this.product, this.price, this.quantity, this.idd});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return _$OrderItemsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderItemsToJson(this);
  }
}
