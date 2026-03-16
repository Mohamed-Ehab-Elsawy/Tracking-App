import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

abstract interface class OrderDetailsRepository {
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId});

  Future<Result<OrderEntity>> updateOrderStatus(OrderStatus status);
  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  });

  Future<Result<void>> saveNotification({
    required NotificationDto notification,
    required String userId,
  });
  Future<Result<List<List<double>>>> getDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  );
}
