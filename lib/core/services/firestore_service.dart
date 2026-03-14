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
    await _dbFirestore.collection(collectionPath).doc(userId).update(data);
  }

  @override
  Future<Map<String, dynamic>> get({
    required String collectionPath,
    required String userId,
  }) async {
    return await _dbFirestore.collection(collectionPath).doc(userId).get().then(
      (doc) {
        return doc.data() as Map<String, dynamic>;
      },
    );
  }
}
