import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStoreService {
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

class DatabaseServiceImpl extends FirebaseStoreService {
  final FirebaseFirestore dbFirestore = FirebaseFirestore.instance;

  @override
  Future<void> set({
    required String collectionPath,
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await dbFirestore.collection(collectionPath).doc(userId).set(data);
  }

  @override
  Future<Map<String, dynamic>> get({
    required String collectionPath,
    required String userId,
  }) async {
    return await dbFirestore.collection(collectionPath).doc(userId).get().then((
      doc,
    ) {
      return doc.data() as Map<String, dynamic>;
    });
  }
}
