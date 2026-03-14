import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/firestore_service.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source_impl.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

class MockFirebaseStoreService extends Mock implements FirebaseStoreService {}

void main() {
  late FirebaseStoreService store;
  late OrderDetailsRemoteDataSource dataSource;

  const orderId = 'order_123';

  Map<String, dynamic> sampleOrderMap({String? id, String status = 'pending'}) {
    return {
      if (id != null) 'id': id,
      'status': status,
      'createdAt': '2024-01-01T12:00:00Z',
      'storeName': 'Store',
      'storeAddress': 'Address',
      'storePhone': '0100000000',
      'userName': 'User',
      'userAddress': 'User Address',
      'userPhone': '0111111111',
      'paymentMethod': 'cash',
      'details': [],
    };
  }

  setUp(() {
    store = MockFirebaseStoreService();
    dataSource = OrderDetailsRemoteDataSourceImpl(store);
  });

  tearDown(() {
    reset(store);
  });

  group('getCurrentOrderDetails', () {
    test('returns Success<OrderEntity> on success', () async {
      // Arrange
      when(
        () => store.get(
          collectionPath: AppConstants.activeOrderCollectionKey,
          userId: orderId,
        ),
      ).thenAnswer((_) async => sampleOrderMap(id: orderId, status: 'pending'));

      // Act
      final result = await dataSource.getCurrentOrderDetails(orderId);

      // Assert
      expect(result, isA<Success<OrderEntity>>());
      final data = (result as Success<OrderEntity>).data;
      expect(data.status, 'pending');
      expect(data.id, orderId);

      verify(
        () => store.get(
          collectionPath: AppConstants.activeOrderCollectionKey,
          userId: orderId,
        ),
      ).called(1);
      verifyNoMoreInteractions(store);
    });

    test('returns Failure<OrderEntity> when Firestore throws', () async {
      // Arrange
      when(
        () => store.get(
          collectionPath: AppConstants.activeOrderCollectionKey,
          userId: orderId,
        ),
      ).thenThrow(Exception('network error'));

      // Act
      final result = await dataSource.getCurrentOrderDetails(orderId);

      // Assert
      expect(result, isA<Failure<OrderEntity>>());

      verify(
        () => store.get(
          collectionPath: AppConstants.activeOrderCollectionKey,
          userId: orderId,
        ),
      ).called(1);
      verifyNoMoreInteractions(store);
    });
  });

  group('updateOrderStatus', () {
    test(
      'updates status and returns Success<OrderEntity> with refreshed doc',
      () async {
        // Arrange
        const newStatus = OrderStatus.delivered;
        when(
          () => store.update(
            collectionPath: AppConstants.activeOrderCollectionKey,
            docID: orderId,
            data: {AppConstants.activeOrderStatusKey: newStatus.name},
          ),
        ).thenAnswer((_) async {});

        when(
          () => store.get(
            collectionPath: AppConstants.activeOrderCollectionKey,
            userId: orderId,
          ),
        ).thenAnswer(
          (_) async => sampleOrderMap(id: orderId, status: newStatus.name),
        );

        // Act
        final result = await dataSource.updateOrderStatus(orderId, newStatus);

        // Assert
        expect(result, isA<Success<OrderEntity>>());
        final data = (result as Success<OrderEntity>).data;
        expect(data.status, equals(newStatus.name));
        expect(data.id, orderId);

        verify(
          () => store.update(
            collectionPath: AppConstants.activeOrderCollectionKey,
            docID: orderId,
            data: {AppConstants.activeOrderStatusKey: newStatus.name},
          ),
        ).called(1);

        verify(
          () => store.get(
            collectionPath: AppConstants.activeOrderCollectionKey,
            userId: orderId,
          ),
        ).called(1);

        verifyNoMoreInteractions(store);
      },
    );

    test('returns Failure<OrderEntity> when update throws', () async {
      // Arrange
      const newStatus = OrderStatus.picked;
      when(
        () => store.update(
          collectionPath: AppConstants.activeOrderCollectionKey,
          docID: orderId,
          data: {AppConstants.activeOrderStatusKey: newStatus.name},
        ),
      ).thenThrow(Exception('permission denied'));

      // Act
      final result = await dataSource.updateOrderStatus(orderId, newStatus);

      // Assert
      expect(result, isA<Failure<OrderEntity>>());

      verify(
        () => store.update(
          collectionPath: AppConstants.activeOrderCollectionKey,
          docID: orderId,
          data: {AppConstants.activeOrderStatusKey: newStatus.name},
        ),
      ).called(1);
      // No get() should be attempted after a failed update
      verifyNoMoreInteractions(store);
    });

    test(
      'returns Failure<OrderEntity> when fetching updated doc throws',
      () async {
        // Arrange
        const newStatus = OrderStatus.accepted;
        when(
          () => store.update(
            collectionPath: AppConstants.activeOrderCollectionKey,
            docID: orderId,
            data: {AppConstants.activeOrderStatusKey: newStatus.name},
          ),
        ).thenAnswer((_) async {});

        when(
          () => store.get(
            collectionPath: AppConstants.activeOrderCollectionKey,
            userId: orderId,
          ),
        ).thenThrow(Exception('not found'));

        // Act
        final result = await dataSource.updateOrderStatus(orderId, newStatus);

        // Assert
        expect(result, isA<Failure<OrderEntity>>());

        verify(
          () => store.update(
            collectionPath: AppConstants.activeOrderCollectionKey,
            docID: orderId,
            data: {AppConstants.activeOrderStatusKey: newStatus.name},
          ),
        ).called(1);

        verify(
          () => store.get(
            collectionPath: AppConstants.activeOrderCollectionKey,
            userId: orderId,
          ),
        ).called(1);

        verifyNoMoreInteractions(store);
      },
    );
  });
}
