import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source_impl.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'fire_base_order_details_data_source_impl_test.mocks.dart';

typedef Json = Map<String, dynamic>;

typedef JsonCollectionRef = CollectionReference<Json>;
typedef JsonDocumentRef = DocumentReference<Json>;
typedef JsonDocumentSnapshot = DocumentSnapshot<Json>;

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<JsonCollectionRef>(),
  MockSpec<JsonDocumentRef>(),
  MockSpec<JsonDocumentSnapshot>(),
])
void main() {
  late MockApiClient mockApiClient;
  late MockFirebaseFirestore mockFirestore;
  late FirebaseOrderDetailsDataSourceImpl dataSource;

  late MockJsonCollectionRef mockCollection;
  late MockJsonDocumentRef mockDoc;
  late MockJsonDocumentSnapshot mockSnapshot;

  setUp(() {
    mockApiClient = MockApiClient();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockJsonCollectionRef();
    mockDoc = MockJsonDocumentRef();
    mockSnapshot = MockJsonDocumentSnapshot();

    dataSource = FirebaseOrderDetailsDataSourceImpl(
      mockApiClient,
      mockFirestore,
    );
  });

  test('saveNotification → Success', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockDoc.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockCollection.add(any)).thenAnswer((_) async => mockDoc);

    final result = await dataSource.saveNotification(
      notification: NotificationDto(title: "title", body: "body"),
      userId: "user1",
    );

    expect(result, isA<Success>());
  });

  test('saveNotification → Failure', () async {
    when(mockFirestore.collection(any)).thenThrow(Exception());

    final result = await dataSource.saveNotification(
      notification: NotificationDto(title: "title", body: "body"),
      userId: "user1",
    );

    expect(result, isA<Failure>());
  });

  test('getCurrentOrderDetails → Success with data', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.data()).thenReturn({"id": "1"});

    final result = await dataSource.getCurrentOrderDetails("order1");

    expect(result, isA<Success>());
  });

  test('getCurrentOrderDetails → Success with empty data', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.data()).thenReturn(null);

    final result = await dataSource.getCurrentOrderDetails("order1");

    expect(result, isA<Success>());
  });

  test('getCurrentOrderDetails → Failure', () async {
    when(mockFirestore.collection(any)).thenThrow(Exception());

    final result = await dataSource.getCurrentOrderDetails("order1");

    expect(result, isA<Failure>());
  });

  test('updateOrderStatus → Success', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);

    when(mockDoc.update(any)).thenAnswer((_) async {});
    when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
    when(mockSnapshot.data()).thenReturn({"id": "1"});

    final result = await dataSource.updateOrderStatus(
      "order1",
      OrderStatus.accepted,
    );

    expect(result, isA<Success>());
  });

  test('updateOrderStatus → Failure on update', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
    when(mockDoc.update(any)).thenThrow(Exception());

    final result = await dataSource.updateOrderStatus(
      "order1",
      OrderStatus.accepted,
    );

    expect(result, isA<Failure>());
  });

  test('updateOrderStatus → Failure on get', () async {
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);

    when(mockDoc.update(any)).thenAnswer((_) async {});
    when(mockDoc.get()).thenThrow(Exception());

    final result = await dataSource.updateOrderStatus(
      "order1",
      OrderStatus.accepted,
    );

    expect(result, isA<Failure>());
  });
}
