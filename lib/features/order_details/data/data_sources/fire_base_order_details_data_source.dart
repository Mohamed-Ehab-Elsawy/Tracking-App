import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';

abstract interface class FirebaseOrderDetailsDataSource {
  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  });

  Future<Result<void>> saveNotification({
    required NotificationDto notification,
    required String userId,
  });
}
