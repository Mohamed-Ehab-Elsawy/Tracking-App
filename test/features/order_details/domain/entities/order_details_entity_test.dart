import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_details_entity.dart';

void main() {
  group('OrderDetailsEntity', () {
    const tId = '1';
    const tTitle = 'Test Item';
    const tPrice = '100.0';
    const tCount = 2;

    test('should return a valid model from constructor', () {
      final entity = OrderDetailsEntity(tId, tTitle, tPrice, tCount);

      expect(entity.id, tId);
      expect(entity.title, tTitle);
      expect(entity.price, tPrice);
      expect(entity.count, tCount);
    });

    group('fromMap', () {
      test('should return a valid model when the JSON map is correct', () {
        final Map<String, dynamic> map = {
          'id': tId,
          'title': tTitle,
          'price': tPrice,
          'count': tCount,
        };

        final result = OrderDetailsEntity.fromMap(map);

        expect(result.id, tId);
        expect(result.title, tTitle);
        expect(result.price, tPrice);
        expect(result.count, tCount);
      });

      test(
        'should return default values when map fields are null or missing',
        () {
          final Map<String, dynamic> map = {};

          final result = OrderDetailsEntity.fromMap(map);

          expect(result.id, '');
          expect(result.title, '');
          expect(result.price, '');
          expect(result.count, 0);
        },
      );

      test(
        'should handle explicit null values in map using null-coalescing logic',
        () {
          final Map<String, dynamic> map = {
            'id': null,
            'title': null,
            'price': null,
            'count': null,
          };

          final result = OrderDetailsEntity.fromMap(map);

          expect(result.id, '');
          expect(result.title, '');
          expect(result.price, '');
          expect(result.count, 0);
        },
      );
    });
  });
}
