import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/core/api/client/api_client.dart';

import '../../../auth/data/data_source/auth_remote_data_source_impl_test.mocks.dart';
import '../../../home/data/repo/home_repo_impl_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, ApiClient])
void main() {
  late FirebaseFirestore mockFirestore;
  late ApiClient mockApiClient;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockApiClient = MockApiClient();
  });
  test('', () async {});
}
