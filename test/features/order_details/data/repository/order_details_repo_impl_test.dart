import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/repository/order_details_repo_impl.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

import 'order_details_repo_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  FirebaseOrderDetailsDataSource,
])
void main() {
  late OrderDetailsRepoImpl repo;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseOrderDetailsDataSource mockFirebaseOrderDetailsDataSource;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    mockFirebaseOrderDetailsDataSource = MockFirebaseOrderDetailsDataSource();

    // Inject the mock here
    repo = OrderDetailsRepoImpl(
      mockFirestore,
      mockFirebaseOrderDetailsDataSource,
    );

    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocument);
  });

  group('getCurrentOrderDetails', () {
    final tOrderData = {'id': '123', 'status': 'pending'};

    test('should return Success when firestore returns data', () async {
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(tOrderData);

      final result = await repo.getCurrentOrderDetails(orderId: '123');

      expect(result, isA<Success<OrderEntity>>());
      verify(mockFirestore.collection('active_orders')).called(1);
    });

    test('should return Failure on FirebaseException', () async {
      when(mockDocument.get()).thenThrow(
        FirebaseException(plugin: 'firestore', message: 'network-error'),
      );

      final result = await repo.getCurrentOrderDetails(orderId: '123');

      expect(result, isA<Failure>());
      expect((result as Failure).errorMessage, 'network-error');
    });
  });
}
