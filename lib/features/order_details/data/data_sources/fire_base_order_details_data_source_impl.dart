import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@Injectable(as: FirebaseOrderDetailsDataSource)
class FirebaseOrderDetailsDataSourceImpl
    implements FirebaseOrderDetailsDataSource {
  final ApiClient _apiClient;
  final FirebaseFirestore _firestore;

  const FirebaseOrderDetailsDataSourceImpl(this._apiClient, this._firestore);

  @override
  Future<Result<void>> sendNotification({
    required SendNotificationRequest sendNotificationRequest,
    required String authorization,
  }) {
    return executeApi(
      () => _apiClient.sendNotification(
        request: sendNotificationRequest,
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

  @override
  Future<Result<ActiveOrderDto>> getCurrentOrderDetails(String orderId) async =>
      executeApi(() async {
        final docRef = await _firestore
            .collection(AppConstants.activeOrdersKey)
            .doc(orderId)
            .get();
        return ActiveOrderDto.fromJson(docRef.data() ?? {});
      });

  @override
  Future<Result<ActiveOrderDto>> updateOrderStatus(
    String orderId,
    double lat,
    double lng,
    OrderStatus status,
  ) async => executeApi(() async {
    await _firestore
        .collection(AppConstants.activeOrdersKey)
        .doc(orderId)
        .update({
          AppConstants.activeOrderStatusKey: status.name,
          AppConstants.activeOrderLatKey: lat.toString(),
          AppConstants.activeOrderLngKey: lng.toString(),
        });

    final docRef = await _firestore
        .collection(AppConstants.activeOrdersKey)
        .doc(orderId)
        .get();
    return ActiveOrderDto.fromJson(docRef.data() ?? {});
  });
}
