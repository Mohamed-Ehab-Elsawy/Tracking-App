import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/data/repository/order_details_repository_impl.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'order_details_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OrderDetailsRemoteDataSource>()])
void main() {
  late OrderDetailsRepositoryImpl repository;
  late MockOrderDetailsRemoteDataSource mockRemoteDataSource;
  late Result<OrderEntity> response;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      AppConstants.orderId: 'cached_order_id_123',
    });

    mockRemoteDataSource = MockOrderDetailsRemoteDataSource();
    repository = OrderDetailsRepositoryImpl(mockRemoteDataSource);
    response = Success(
      OrderEntity(id: "direct_id_456", storeName: "Senior Flutter Store"),
    );
  });

  group('getCurrentOrderDetails', () {
    test('returns remote data when orderId is explicitly provided', () async {
      provideDummy<Result<OrderEntity>>(response);
      when(
        mockRemoteDataSource.getCurrentOrderDetails('direct_id_456'),
      ).thenAnswer((_) async => response);

      final result = await repository.getCurrentOrderDetails(
        orderId: 'direct_id_456',
      );

      expect(result, equals(response));
      verify(
        mockRemoteDataSource.getCurrentOrderDetails('direct_id_456'),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
      'returns remote data using cached orderId when orderId is null',
      () async {
        when(
          mockRemoteDataSource.getCurrentOrderDetails('cached_order_id_123'),
        ).thenAnswer((_) async => response);

        final result = await repository.getCurrentOrderDetails();

        expect(result, equals(response));
        verify(
          mockRemoteDataSource.getCurrentOrderDetails('cached_order_id_123'),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('updateOrderStatus', () {
    test(
      'updates status via remote data source using cached orderId',
      () async {
        final tOrderStatus = OrderStatus.values.first;

        when(
          mockRemoteDataSource.updateOrderStatus(
            'cached_order_id_123',
            tOrderStatus,
          ),
        ).thenAnswer((_) async => response);

        final result = await repository.updateOrderStatus(tOrderStatus);

        expect(result, equals(response));
        verify(
          mockRemoteDataSource.updateOrderStatus(
            'cached_order_id_123',
            tOrderStatus,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
