import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/services/firestore_service.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDoc;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  late DatabaseServiceImpl service;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDoc = MockDocumentReference<Map<String, dynamic>>();
    mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    service = DatabaseServiceImpl(mockFirestore);

    // Firestore plumbing
    when(mockFirestore.collection(any)).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDoc);
  });

  group("DatabaseServiceImpl.set()", () {
    test("calls set() then update() with correct data", () async {
      final data = {"name": "John"};

      when(mockDoc.set(any)).thenAnswer((_) async {});
      when(mockDoc.update(any)).thenAnswer((_) async {});

      await service.set(collectionPath: "users", userId: "123", data: data);

      verify(mockFirestore.collection("users")).called(2);
      verify(mockCollection.doc("123")).called(2);
      verify(mockDoc.set(data)).called(1);
      verify(mockDoc.update(data)).called(1);
    });
  });

  group("DatabaseServiceImpl.get()", () {
    test("returns parsed Map<String, dynamic> from Firestore", () async {
      final expectedData = {"age": 30, "active": true};

      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(expectedData);

      final result = await service.get(
        collectionPath: "profiles",
        userId: "u1",
      );

      expect(result, expectedData);
    });

    test("throws if data() is null", () async {
      when(mockDoc.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn(null);

      expect(
        () => service.get(collectionPath: "profiles", userId: "u1"),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
