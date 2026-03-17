import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/api/di/firebase_module.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  group('FirebaseModule', () {
    final module = _TestFirebaseModule();

    test('should provide FirebaseFirestore instance', () {
      final firestore = module.firestore;

      expect(firestore, isA<FirebaseFirestore>());
    });

    test('should return same instance because it is lazySingleton', () {
      final firestore1 = module.firestore;
      final firestore2 = module.firestore;

      expect(identical(firestore1, firestore2), true);
    });
  });
}

class _TestFirebaseModule extends FirebaseModule {}
