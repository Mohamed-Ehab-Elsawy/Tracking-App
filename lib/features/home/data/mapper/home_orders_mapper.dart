import 'package:tracking_app/features/home/data/models/orders_dto.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';

extension HomeOrdersMapper on OrdersDto {
  HomeOrderEntity toEntity() {
    return HomeOrderEntity(
      orderId: id,
      storeName: store?.name,
      storeAddress: store?.address,
      storeImage: store?.image,
      userName: '${user?.firstName} ${user?.lastName}',
      totalPrice: (totalPrice ?? 0).toDouble(),
      status: state,
      userId: user?.id,
      userImage: "https://flower.elevateegy.com/uploads/${user?.photo}",
      userAddress: shippingAddress != null
          ? '${shippingAddress?.street ?? ''}, ${shippingAddress?.city ?? ''}'
          : null,
      street: shippingAddress?.street,
      city: shippingAddress?.city,
      phone: shippingAddress?.phone,
      lat: shippingAddress?.lat,
      long: shippingAddress?.long,
    );
  }
}
