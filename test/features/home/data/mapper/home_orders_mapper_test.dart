import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/data/mapper/home_orders_mapper.dart';
import 'package:tracking_app/features/home/data/models/orders_dto.dart';
import 'package:tracking_app/features/home/data/models/shipping_address.dart';
import 'package:tracking_app/features/home/data/models/store_dto.dart';
import 'package:tracking_app/features/home/data/models/user_dto.dart';

void main() {
  test('home orders  mapper  should return entity', () async {
    //arrange
    final dto = OrdersDto(
      id: '1',
      store: StoreDto(name: 'name', address: 'address', image: 'image'),
      user: UserDto(
        firstName: 'firstName',
        lastName: 'lastName',
        photo: 'photo',
      ),
      shippingAddress: ShippingAddress(street: 'street', city: 'city'),
      totalPrice: 1,
      state: 'state',
    );
    //act
    final entity = dto.toEntity();

    //assert
    expect(entity.orderId, dto.id);
    expect(entity.storeName, dto.store?.name);
    expect(entity.storeAddress, dto.store?.address);
    expect(entity.storeImage, dto.store?.image);
    expect(entity.userName, '${dto.user?.firstName} ${dto.user?.lastName}');
    expect(entity.totalPrice, dto.totalPrice);
    expect(entity.status, dto.state);
    expect(entity.userId, dto.user?.id);
    expect(
      entity.userImage,
      'https://flower.elevateegy.com/uploads/${dto.user?.photo}',
    );
    expect(
      entity.userAddress,
      '${dto.shippingAddress?.street}, ${dto.shippingAddress?.city}',
    );
  });

  test('Mapper should provide default values for null price and id', () {
    // Arrange
    final dto = OrdersDto(id: null, totalPrice: null, state: null);

    // Act
    final entity = dto.toEntity();

    // Assert
    expect(entity.orderId, isNull);
    expect(entity.totalPrice, 0.0);
    expect(entity.status, isNull);
  });
}
