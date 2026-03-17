import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source_impl.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'order_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  ApiClient,
])
void main() {
  late FirebaseOrderDetailsDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockApiClient mockApiClient;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    mockApiClient = MockApiClient();

    dataSource = FirebaseOrderDetailsDataSourceImpl(
      mockApiClient,
      mockFirestore,
    );

    when(mockFirestore.collection('active_orders')).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocRef);
  });

  group('getCurrentOrderDetails', () {
    const tOrderId = 'order_123';
    final tMap = {'id': tOrderId, 'status': 'pending'};

    test('returns Success with OrderEntity when document exists', () async {
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(tMap);

      final result = await dataSource.getCurrentOrderDetails(tOrderId);

      expect(result, isA<Success>());
      verify(mockFirestore.collection('active_orders')).called(1);
      verify(mockCollection.doc(tOrderId)).called(1);
      verify(mockDocRef.get()).called(1);
    });

    test('returns Failure with not_found when document data is null', () async {
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(null);

      final result = await dataSource.getCurrentOrderDetails(tOrderId);

      expect(result, isA<Failure>());
    });

    test('returns Failure when FirebaseException occurs', () async {
      when(mockDocRef.get()).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          message: 'permission_denied',
        ),
      );

      final result = await dataSource.getCurrentOrderDetails(tOrderId);

      expect(result, isA<Failure>());
    });

    test('returns Failure when generic Exception occurs', () async {
      when(mockDocRef.get()).thenThrow(Exception('generic_error'));

      final result = await dataSource.getCurrentOrderDetails(tOrderId);

      expect(result, isA<Failure>());
    });
  });

  group('updateOrderStatus', () {
    const tOrderId = 'order_123';
    final tStatus = OrderStatus.values.first;
    final tMap = {'id': tOrderId, 'status': tStatus.name};

    test('returns Failure with invalid_params when orderId is empty', () async {
      final result = await dataSource.updateOrderStatus('', tStatus);

      expect(result, isA<Failure>());
      verifyNever(mockFirestore.collection(any));
    });

    test('returns Success when update and fetch are successful', () async {
      when(mockDocRef.update(any)).thenAnswer((_) async => {});
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(tMap);

      final result = await dataSource.updateOrderStatus(tOrderId, tStatus);

      expect(result, isA<Success>());
      verify(mockDocRef.update({'status': tStatus.name})).called(1);
      verify(mockDocRef.get()).called(1);
    });

    test('returns Failure when updated document data is null', () async {
      when(mockDocRef.update(any)).thenAnswer((_) async => {});
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(null);

      final result = await dataSource.updateOrderStatus(tOrderId, tStatus);

      expect(result, isA<Failure>());
    });

    test(
      'returns Failure when FirebaseException occurs during update',
      () async {
        when(mockDocRef.update(any)).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            message: 'network_error',
          ),
        );

        final result = await dataSource.updateOrderStatus(tOrderId, tStatus);

        expect(result, isA<Failure>());
        verifyNever(mockDocRef.get());
      },
    );

    test(
      'returns Failure when generic Exception occurs during update',
      () async {
        when(mockDocRef.update(any)).thenThrow(Exception('generic_error'));

        final result = await dataSource.updateOrderStatus(tOrderId, tStatus);

        expect(result, isA<Failure>());
        verifyNever(mockDocRef.get());
      },
    );
  });
}
