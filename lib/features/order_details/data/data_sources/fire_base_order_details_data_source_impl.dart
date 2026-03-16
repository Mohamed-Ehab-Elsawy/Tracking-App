import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';

@Injectable(as: FirebaseOrderDetailsDataSource)
class FirebaseOrderDetailsDataSourceImpl
    implements FirebaseOrderDetailsDataSource {
  final ApiClient _apiClient;
  final FirebaseFirestore _firestore;
  const FirebaseOrderDetailsDataSourceImpl(this._apiClient, this._firestore);
  @override
  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  }) {
    return executeApi(
      () => _apiClient.sendNotification(
        notificationDto: notificationDto,
        authorization: authorization,
      ),
    );
  }

  @override
  Future<Result<void>> saveNotification({
    required NotificationDto notification,
    required String userId,
  }) {
    return executeApi(
      () async => await _firestore
          .collection("users")
          .doc(userId)
          .collection("notifications")
          .add(notification.toJson()),
    );
  }
}
