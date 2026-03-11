import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

void main() {
  group('OrderEntity', () {
    const tId = 'order_123';
    const tStatus = 'pending';
    const tStoreName = 'Tech Store';
    const tUserAddress = '123 Flutter Lane';

    test(
      'should return a valid entity from constructor with default values',
      () {
        final entity = OrderEntity();

        expect(entity.id, '');
        expect(entity.status, '');
        expect(entity.details, isEmpty);
      },
    );

    group('fromMap', () {
      test('should return a valid model when the JSON map is complete', () {
        final Map<String, dynamic> map = {
          'id': tId,
          'status': tStatus,
          'createdAt': '2026-03-11',
          'storeName': tStoreName,
          'storeAddress': 'Store Addr',
          'storePhone': '123456',
          'userName': 'John Doe',
          'userAddress': tUserAddress,
          'userPhone': '654321',
          'paymentMethod': 'cash',
          'details': [
            {'id': 'item_1', 'title': 'Laptop', 'price': '1000', 'count': 1},
            {'id': 'item_2', 'title': 'Mouse', 'price': '50', 'count': 2},
          ],
        };

        final result = OrderEntity.fromMap(map);

        expect(result.id, tId);
        expect(result.status, tStatus);
        expect(result.storeName, tStoreName);
        expect(result.userAddress, tUserAddress);
        expect(result.details.length, 2);
        expect(result.details[0], isA<OrderDetailsEntity>());
        expect(result.details[0].title, 'Laptop');
      });

      test(
        'should handle missing or null details list by providing an empty list',
        () {
          final Map<String, dynamic> map = {'id': tId, 'details': null};

          final result = OrderEntity.fromMap(map);

          expect(result.id, tId);
          expect(result.details, isA<List<OrderDetailsEntity>>());
          expect(result.details, isEmpty);
        },
      );

      test(
        'should fallback to default values for all fields when map is empty',
        () {
          final Map<String, dynamic> map = {};

          final result = OrderEntity.fromMap(map);

          expect(result.id, '');
          expect(result.status, '');
          expect(result.storeName, '');
          expect(result.details, isEmpty);
        },
      );
    });
  });
}
