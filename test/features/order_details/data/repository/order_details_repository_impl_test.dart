import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart'; // Add this
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/repository/order_details_repository_impl.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'order_details_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseOrderDetailsDataSource>(),
  MockSpec<ApiClient>(),
  MockSpec<AppLocalStorage>(),
])
void main() {
  late OrderDetailsRepositoryImpl repository;
  late MockFirebaseOrderDetailsDataSource mockRemoteDataSource;
  late MockApiClient mockApiClient;
  late Result<ActiveOrderDto> response;

  setUp(() {
    mockRemoteDataSource = MockFirebaseOrderDetailsDataSource();
    mockApiClient = MockApiClient();

    repository = OrderDetailsRepositoryImpl(
      mockRemoteDataSource,
      mockApiClient,
    );

    response = Success(
      ActiveOrderDto(
        orderId: "direct_id_456",
        storeName: "Senior Flutter Store",
      ),
    );
  });

  group('getCurrentOrderDetails', () {
    test('returns remote data when orderId is explicitly provided', () async {
      provideDummy<Result<ActiveOrderDto>>(response);

      when(
        mockRemoteDataSource.getCurrentOrderDetails('direct_id_456'),
      ).thenAnswer((_) async => response);

      final result = await repository.getCurrentOrderDetails();

      expect(result, equals(response));
      verify(
        mockRemoteDataSource.getCurrentOrderDetails('direct_id_456'),
      ).called(1);
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
      },
    );
  });
}
