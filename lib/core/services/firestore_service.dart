import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract interface class FirebaseStoreService {
  Future<void> set({
    required String collectionPath,
    required String userId,
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>> get({
    required String collectionPath,
    required String userId,
  });

  Future<Map<String, dynamic>> updateThenFetch({
    required String collectionPath,
    required String docID,
    required Map<String, dynamic> data,
  });
}

@LazySingleton(as: FirebaseStoreService)
class DatabaseServiceImpl implements FirebaseStoreService {
  final FirebaseFirestore _dbFirestore;

  DatabaseServiceImpl(this._dbFirestore);

  @override
  Future<void> set({
    required String collectionPath,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _dbFirestore.collection(collectionPath).doc(userId).set(data);
  }

  @override
  Future<Map<String, dynamic>> get({
    required String collectionPath,
    required String userId,
  }) async {
    var doc = await _dbFirestore.collection(collectionPath).doc(userId).get();
    return doc.data() ?? {};
  }

  @override
  Future<Map<String, dynamic>> updateThenFetch({
    required String collectionPath,
    required String docID,
    required Map<String, dynamic> data,
  }) async {
    var doc = await _dbFirestore
        .collection(collectionPath)
        .doc(docID)
        .update(data)
        .then(
          (value) => _dbFirestore.collection(collectionPath).doc(docID).get(),
        );
    return doc.data() ?? {};
  }
}
